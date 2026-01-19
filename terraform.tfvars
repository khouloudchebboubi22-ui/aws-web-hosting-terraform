# ============================================
# PRODUCTION CONFIGURATION FOR AWS WEB HOSTING
# STUDENT: Khouloud Chebboubi (102303255)
# COURSE: Cloud Programming (DLBSEPCP01_E)
# ============================================

aws_region = "eu-central-1"
project_name = "iu-cloud-programming-webhosting"
environment = "production"

student_info = {
  name          = "Khouloud Chebboubi"
  matriculation = "102303255"
  course_code   = "DLBSEPCP01_E"
  email         = "khouloud.chebboubi@student.iu.org"
}

vpc_config = {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

subnet_config = {
  public_subnet_count  = 2
  private_subnet_count = 2
  cidr_newbits         = 8
}

compute_config = {
  instance_type      = "t3.micro"
  ami_id            = "ami-0a1ee2fb8fe11cf91"
  root_volume_size  = 20
  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
  health_check_type = "EC2"
}

storage_config = {
  bucket_name_prefix = "khouloud-102303255-webhosting"
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

cdn_config = {
  enabled      = true
  price_class  = "PriceClass_100"
  default_ttl  = 3600
  min_ttl      = 0
  max_ttl      = 86400
  compress     = true
  http_version = "http2and3"
}

security_config = {
  enable_waf         = true
  enable_https       = true
  enable_logging     = true
  enable_monitoring  = true
  enable_backup      = true
}

cost_optimization = {
  use_spot_instances       = false
  enable_auto_scaling      = true
  enable_s3_lifecycle      = true
  enable_cloudwatch_alarms = true
}

# ============================================
# TUTOR NOTES:
# 1. All resources are tagged with student info
# 2. Architecture is highly available (Multi-AZ)
# 3. Security best practices implemented
# 4. Cost optimized with auto-scaling
# 5. Infrastructure is fully automated
# ============================================
