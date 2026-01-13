# AWS Web Hosting - Terraform Infrastructure

**Student:** Khouloud Chebboubi  
**Matriculation:** 102303255  
**Course:** Cloud Programming (DLBSEPCP01_E)  
**Project:** Highly Available Web Hosting on AWS

##  Project Overview
Complete AWS cloud architecture for hosting a highly available, globally accessible website with auto-scaling capabilities.

##  Architecture Components
- **VPC**: Multi-AZ network infrastructure (3 Availability Zones)
- **EC2**: Auto-scaling compute instances (t3.small)
- **S3**: Static content hosting with versioning
- **CloudFront**: Global CDN with 310+ edge locations
- **ALB**: Application Load Balancer with SSL termination
- **Auto Scaling**: CPU-based scaling policies
- **Security**: WAF, IAM, encryption, security groups

##  Quick Deployment

```bash
# 1. Initialize Terraform
terraform init

# 2. Review deployment plan
terraform plan

# 3. Deploy infrastructure
terraform apply -auto-approve

# 4. Upload website files
aws s3 sync ./website s3://$(terraform output -raw s3_bucket_name)
