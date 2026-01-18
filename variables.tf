variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment (dev, test, prod)"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["dev", "test", "production"], var.environment)
    error_message = "Environment must be dev, test, or production."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "enable_cloudfront" {
  description = "Enable CloudFront CDN"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Custom domain name (optional)"
  type        = string
  default     = ""
}
