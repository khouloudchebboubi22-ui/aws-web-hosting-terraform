# modules/dns/outputs.tf
output "cloudfront_record_name" {
  description = "Name of the CloudFront Route53 record"
  value       = try(aws_route53_record.cloudfront[0].name, "")
}

output "www_record_name" {
  description = "Name of the WWW Route53 record"
  value       = try(aws_route53_record.www[0].name, "")
}
