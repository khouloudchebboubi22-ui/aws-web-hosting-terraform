# ============================================
# INPUT VARIABLES FOR AWS WEB HOSTING
# ============================================

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-central-1"
  validation {
    condition     = contains(["eu-central-1", "us-east-1", "us-west-2"], var.aws_region)
    error_message = "Region must be eu-central-1, us-east-1, or us-west-2."
  }
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "web-hosting"
  validation {
    condition     = length(var.project_name) <= 20
    error_message = "Project name must be 20 characters or less."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "student_info" {
  description = "Student information for tagging"
  type = object({
    name           = string
    matriculation  = string
    course_code    = string
    email          = optional(string, "student@iu.org")
  })
  default = {
    name          = "Khouloud Chebboubi"
    matriculation = "102303255"
    course_code   = "DLBSEPCP01_E"
  }
}

variable "vpc_config" {
  description = "VPC configuration parameters"
  type = object({
    cidr_block            = string
    enable_dns_hostnames  = bool
    enable_dns_support    = bool
    instance_tenancy      = string
  })
  default = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"
  }
}

variable "subnet_config" {
  description = "Subnet configuration for high availability"
  type = object({
    public_subnet_count  = number
    private_subnet_count = number
    cidr_newbits         = number
  })
  default = {
    public_subnet_count  = 2
    private_subnet_count = 2
    cidr_newbits         = 8
  }
}

variable "compute_config" {
  description = "Compute resources configuration"
  type = object({
    instance_type        = string
    ami_id              = string
    root_volume_size    = number
    min_size            = number
    max_size            = number
    desired_capacity    = number
    health_check_type   = string
  })
  default = {
    instance_type      = "t3.micro"
    ami_id            = "ami-0a1ee2fb8fe11cf91" # Amazon Linux 2023
    root_volume_size  = 20
    min_size          = 2
    max_size          = 4
    desired_capacity  = 2
    health_check_type = "EC2"
  }
}

variable "storage_config" {
  description = "Storage configuration for static website"
  type = object({
    bucket_name_prefix = string
    bucket_versioning  = bool
    static_files = list(object({
      name        = string
      content_type = string
      path        = string
    }))
  })
  default = {
    bucket_name_prefix = "khouloud-webhosting"
    bucket_versioning  = true
    static_files = [
      {
        name         = "index.html"
        content_type = "text/html"
        path         = "website/index.html"
      },
      {
        name         = "error.html"
        content_type = "text/html"
        path         = "website/error.html"
      },
      {
        name         = "health.html"
        content_type = "text/html"
        path         = "website/health.html"
      }
    ]
  }
}

variable "cdn_config" {
  description = "CloudFront CDN configuration"
  type = object({
    enabled             = bool
    price_class         = string
    default_ttl         = number
    min_ttl             = number
    max_ttl             = number
    compress            = bool
    http_version        = string
  })
  default = {
    enabled      = true
    price_class  = "PriceClass_100" # Europe, North America, Israel
    default_ttl  = 3600
    min_ttl      = 0
    max_ttl      = 86400
    compress     = true
    http_version = "http2and3"
  }
}

variable "security_config" {
  description = "Security configuration parameters"
  type = object({
    enable_waf          = bool
    enable_https        = bool
    enable_logging      = bool
    enable_monitoring   = bool
    enable_backup       = bool
  })
  default = {
    enable_waf         = true
    enable_https       = true
    enable_logging     = true
    enable_monitoring  = true
    enable_backup      = true
  }
}

variable "cost_optimization" {
  description = "Cost optimization settings"
  type = object({
    use_spot_instances      = bool
    enable_auto_scaling     = bool
    enable_s3_lifecycle     = bool
    enable_cloudwatch_alarms = bool
  })
  default = {
    use_spot_instances       = false
    enable_auto_scaling      = true
    enable_s3_lifecycle      = true
    enable_cloudwatch_alarms = true
  }
}
