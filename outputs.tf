output "website_url" {
  description = "CloudFront URL"
  value = aws_cloudfront_distribution.website.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value = aws_s3_bucket.website.bucket
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value = aws_lb.web.dns_name
}
