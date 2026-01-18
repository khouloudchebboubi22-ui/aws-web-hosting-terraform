terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "web-hosting-vpc" }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# 3. Public Subnets (for ALB)
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-${count.index + 1}" }
}

# 4. Private Subnets (for EC2)
resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 101)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "private-subnet-${count.index + 1}" }
}

# 5. Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# 6. S3 Bucket for Static Website
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  tags = { Name = "static-website" }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
}

# 7. Security Groups
resource "aws_security_group" "alb" {
  name = "alb-sg"
  vpc_id = aws_vpc.main.id
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. Application Load Balancer
resource "aws_lb" "web" {
  name = "web-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = aws_subnet.public[*].id
}

# 9. Launch Template for EC2
resource "aws_launch_template" "web" {
  name_prefix = "web-"
  image_id = var.ami_id
  instance_type = var.instance_type
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello World from AWS" > /var/www/html/index.html
  EOF
  )
}

# 10. Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name = "web-asg"
  min_size = 2
  max_size = 4
  desired_capacity = 2
  vpc_zone_identifier = aws_subnet.private[*].id
  
  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }
}

# 11. CloudFront Distribution
resource "aws_cloudfront_distribution" "website" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id = "S3Origin"
  }
  
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
