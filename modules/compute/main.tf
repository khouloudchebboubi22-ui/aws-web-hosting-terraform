# modules/compute/main.tf
# Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets           = var.public_subnet_ids
  
  enable_deletion_protection = false
  
  tags = {
    Name        = "${var.environment}-web-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
  
  tags = {
    Name        = "${var.environment}-web-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.web.arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ACM Certificate (self-signed for testing)
resource "aws_acm_certificate" "web" {
  domain_name       = "*.amazonaws.com"  # For testing - use your domain in production
  validation_method = "DNS"
  
  tags = {
    Environment = var.environment
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Launch Template for EC2 Instances
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "web_server" {
  name          = "${var.environment}-web-server-lt"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  iam_instance_profile {
    name = var.ec2_iam_instance_profile
  }
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }
  
  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name        = "${var.environment}-web-server"
      Environment = var.environment
      Role        = "webserver"
    }
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    
    # Create health check endpoint
    mkdir -p /var/www/html/api
    cat > /var/www/html/api/health <<'HEALTH'
    {
      "status": "healthy",
      "service": "web-server",
      "timestamp": "$(date)",
      "instance_id": "$(curl -s http://169.254.169.254/latest/meta-data/instance-id)",
      "availability_zone": "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"
    }
    HEALTH
    
    # Create sample dynamic content
    cat > /var/www/html/index.php <<'PHP'
    <!DOCTYPE html>
    <html>
    <head>
        <title>Dynamic Content - EC2 Backend</title>
        <style>
            body { font-family: Arial, sans-serif; padding: 20px; }
            .dynamic { background: #e3f2fd; padding: 20px; border-radius: 10px; }
            .info { background: #f3e5f5; padding: 15px; margin: 10px 0; }
        </style>
    </head>
    <body>
        <div class="dynamic">
            <h2>🖥️ Dynamic Content from EC2</h2>
            <div class="info">
                <strong>Instance ID:</strong> <?php echo file_get_contents('http://169.254.169.254/latest/meta-data/instance-id'); ?><br>
                <strong>Availability Zone:</strong> <?php echo file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone'); ?><br>
                <strong>Current Time:</strong> <?php echo date('Y-m-d H:i:s'); ?>
            </div>
            <p>This content is generated dynamically by PHP on an EC2 instance.</p>
            <p><a href="/">← Back to static homepage</a></p>
        </div>
    </body>
    </html>
    PHP
    
    # Start Apache
    systemctl start httpd
    systemctl enable httpd
    
    # Create static file for testing
    cat > /var/www/html/static/test.txt <<'STATIC'
    This is a static file served from EC2.
    Used to demonstrate routing differences.
    STATIC
    
    echo "Web server setup complete!"
  EOF
  )
  
  tags = {
    Environment = var.environment
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                = "${var.environment}-web-asg"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 6
  health_check_type   = "ELB"
  
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  
  target_group_arns = [aws_lb_target_group.web.arn]
  
  tag {
    key                 = "Name"
    value               = "${var.environment}-web-instance"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.environment}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

# CloudWatch Alarms for Auto Scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 120
  statistic          = "Average"
  threshold          = 70
  alarm_description  = "Scale up when CPU > 70% for 4 minutes"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.environment}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 120
  statistic          = "Average"
  threshold          = 30
  alarm_description  = "Scale down when CPU < 30% for 10 minutes"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
