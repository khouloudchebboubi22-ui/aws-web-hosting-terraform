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

module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "storage" {
  source = "./modules/storage"
  bucket_name = var.bucket_name
  tags = var.tags
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids = module.network.public_subnet_ids
  instance_type = var.instance_type
  key_name = var.key_name
  ami_id = var.ami_id
  tags = var.tags
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
  alb_sg_id = module.compute.alb_sg_id
  ec2_sg_id = module.compute.ec2_sg_id
  cloudfront_oai_iam_arn = module.storage.cloudfront_oai_iam_arn
}

module "dns" {
  source = "./modules/dns"
  cloudfront_domain_name = module.storage.cloudfront_domain_name
  route53_zone_id = var.route53_zone_id
  domain_name = var.domain_name
}
