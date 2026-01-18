output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.static_website.bucket
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_oai_iam_arn" {
  description = "CloudFront OAI IAM ARN"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}
