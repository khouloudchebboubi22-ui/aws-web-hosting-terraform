variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
  default     = ""
}
