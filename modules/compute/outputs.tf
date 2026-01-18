output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID of ALB"
  value       = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "Security Group ID of EC2"
  value       = aws_security_group.ec2.id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}
