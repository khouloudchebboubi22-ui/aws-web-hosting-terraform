# modules/dns/variables.tf
variable "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Route53 zone ID"
  type        = string
  default     = ""
}
