variable "vpc_id" {
  description = "VPC ID for flow logs"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN for WAF association"
  type        = string
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}
