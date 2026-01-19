output "cloudfront_url" {
  description = "CloudFront URL"
  value       = aws_cloudfront_distribution.cdn.domain_name
}
