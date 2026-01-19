# main.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Backend configuration - Important for tutor to run
  backend "local" {
    # Using local backend for simplicity in testing
    # In production, use S3 backend
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "AWS-Web-Hosting"
      Student     = "Khouloud-Chebboubi"
      Course      = "Cloud-Programming"
      Environment = "testing"
    }
  }
}

# Call all modules
module "network" {
  source = "./modules/network"
  
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "security" {
  source = "./modules/security"
  
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
}

module "storage" {
  source = "./modules/storage"
  
  bucket_name         = var.bucket_name
  environment         = var.environment
  cloudfront_oai      = module.security.cloudfront_oai_iam_arn
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  public_subnet_ids   = module.network.public_subnet_ids
  alb_sg_id           = module.security.alb_security_group_id
  ec2_sg_id           = module.security.ec2_security_group_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  environment         = var.environment
}

module "cdn" {
  source = "./modules/cdn"
  
  s3_bucket_regional_domain_name = module.storage.s3_bucket_regional_domain_name
  alb_dns_name                   = module.compute.alb_dns_name
  cloudfront_oai_id              = module.security.cloudfront_oai_id
  environment                    = var.environment
}

# Optional: DNS module if you have a domain
# module "dns" {
#   source = "./modules/dns"
#   cloudfront_domain_name = module.cdn.cloudfront_domain_name
#   domain_name = var.domain_name
#   route53_zone_id = var.route53_zone_id
# }
