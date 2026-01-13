# Terraform Modules

This directory contains reusable Terraform modules:

## Available Modules
1. **Network** - VPC, subnets, routing tables, NAT gateway
2. **Compute** - EC2 instances, Auto Scaling Groups, Launch Templates
3. **Storage** - S3 buckets, CloudFront distributions
4. **Security** - Security groups, IAM roles, WAF rules

## Usage
Each module can be imported in main.tf:

```hcl
module "network" {
  source = "./modules/network"
  # ... variables
}
