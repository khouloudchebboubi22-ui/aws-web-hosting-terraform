# variables.tf
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "testing"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "bucket_name" {
  description = "Name of the S3 bucket for static website"
  type        = string
  default     = "web-static-content-2025-khouloud"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "web-hosting-key"
}

# Optional variables for DNS
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
