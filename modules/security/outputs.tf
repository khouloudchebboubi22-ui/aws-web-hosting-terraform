# modules/security/outputs.tf
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "cloudfront_oai_iam_arn" {
  description = "IAM ARN of the CloudFront OAI"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}

output "cloudfront_oai_id" {
  description = "ID of the CloudFront OAI"
  value       = aws_cloudfront_origin_access_identity.oai.id
}

output "ec2_iam_instance_profile" {
  description = "IAM instance profile for EC2"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = try(aws_wafv2_web_acl.cloudfront.arn, "")
}
