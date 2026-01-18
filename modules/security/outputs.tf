output "waf_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.web.arn
}

output "ec2_iam_role_arn" {
  description = "IAM Role ARN for EC2"
  value       = aws_iam_role.ec2_role.arn
}
