# modules/compute/outputs.tf
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.web.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.web_server.id
}

output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "ec2_instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_autoscaling_group.web.instances
}
