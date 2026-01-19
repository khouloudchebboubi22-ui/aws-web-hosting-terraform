# outputs.tf

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = module.s3_cloudfront.cloudfront_domain
}

output "website_url" {
  description = "S3 static website URL"
  value       = module.s3_cloudfront.website_url
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.ec2.alb_dns_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
