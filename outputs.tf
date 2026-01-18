output "website_url" {
  description = "URL of the deployed website"
  value       = "https://${module.dns.website_fqdn}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.storage.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.storage.s3_bucket_name
}

output "load_balancer_dns" {
  description = "Application Load Balancer DNS"
  value       = module.compute.alb_dns_name
}
