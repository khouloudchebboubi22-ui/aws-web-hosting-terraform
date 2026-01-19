terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Optional: Remote state for team collaboration
  backend "s3" {
    bucket = "khouloud-terraform-state-102303255"
    key    = "cloud-programming/web-hosting/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Student       = "Khouloud Chebboubi"
      Matriculation = "102303255"
      Course        = "Cloud Programming (DLBSEPCP01_E)"
      Project       = "AWS Web Hosting Assignment"
      Environment   = "production"
      ManagedBy     = "Terraform"
    }
  }
}
