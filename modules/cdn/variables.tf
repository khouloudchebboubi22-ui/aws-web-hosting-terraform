# modules/cdn/variables.tf
variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "cloudfront_oai_id" {
  description = "ID of the CloudFront Origin Access Identity"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "testing"
}
