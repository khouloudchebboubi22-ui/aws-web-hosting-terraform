# modules/storage/outputs.tf
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.static_website.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.static_website.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.static_website.bucket_regional_domain_name
}

output "s3_bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = aws_s3_bucket.static_website.website_endpoint
}

output "s3_bucket_website_domain" {
  description = "Website domain of the S3 bucket"
  value       = aws_s3_bucket.static_website.website_domain
}
