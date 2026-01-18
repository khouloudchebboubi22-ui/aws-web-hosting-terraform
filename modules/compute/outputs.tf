# modules/compute/outputs.tf
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.web.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.web.arn
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_autoscaling_group.web.*.id
}
