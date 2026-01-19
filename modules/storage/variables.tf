# modules/storage/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "cloudfront_oai" {
  description = "CloudFront Origin Access Identity IAM ARN"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "testing"
}
