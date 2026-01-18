# outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.compute.alb_dns_name
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = module.cdn.cloudfront_url
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.storage.bucket_name
}

output "website_url" {
  description = "Final website URL"
  value       = "https://${var.domain_name}"
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = module.compute.instance_ids
}
