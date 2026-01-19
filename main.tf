# main.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # You can configure this later for remote state
    # For now, we'll use local state
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

# S3 & CloudFront Module
module "s3_cloudfront" {
  source = "./modules/s3-cloudfront"

  bucket_name       = var.bucket_name
  cf_comment        = "My static website CDN"
  cf_price_class    = "PriceClass_100" # US/Canada/Europe
  alb_dns_name      = module.ec2.alb_dns_name
  alb_zone_id       = module.ec2.alb_zone_id
}

# EC2 & ALB Module
module "ec2" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_type      = var.instance_type
  key_name           = var.key_name
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
}
