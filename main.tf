# main.tf
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
}

# Import modules
module "vpc" {
  source = "./modules/network"
  
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.availability_zones
}

module "security" {
  source = "./modules/security"
  
  vpc_id = module.vpc.vpc_id
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  web_sg_id           = module.security.web_sg_id
  alb_sg_id           = module.security.alb_sg_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  ami_id              = var.ami_id
}

module "storage" {
  source = "./modules/storage"
  
  bucket_name = var.bucket_name
}

module "cdn" {
  source = "./modules/cdn"
  
  bucket_domain_name = module.storage.bucket_domain_name
  alb_dns_name       = module.compute.alb_dns_name
  certificate_arn    = var.certificate_arn
}

module "dns" {
  source = "./modules/dns"
  
  cloudfront_domain_name = module.cdn.cloudfront_domain_name
  zone_id                = var.route53_zone_id
  domain_name            = var.domain_name
}
