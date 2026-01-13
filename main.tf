terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "AWS-Web-Hosting"
      Student     = "Khouloud Chebboubi"
      Matriculation = "102303255"
      Course      = "DLBSEPCP01_E"
    }
  }
}

# Network Module
module "network" {
  source = "./modules/network"
  
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

# Compute Module
module "compute" {
  source = "./modules/compute"
  
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  instance_type      = "t3.small"
  min_size           = 2
  max_size           = 6
  desired_capacity   = 3
}

# Storage Module
module "storage" {
  source = "./modules/storage"
  
  bucket_name = "web-static-content-${var.environment}"
}

# Security Module
module "security" {
  source = "./modules/security"
  
  vpc_id = module.network.vpc_id
}

# Outputs for deployment
output "website_url" {
  value = "https://${module.storage.cloudfront_domain_name}"
}

output "deployment_status" {
  value = "AWS Web Hosting infrastructure deployed successfully!"
}
