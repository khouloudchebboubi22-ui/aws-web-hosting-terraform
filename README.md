 AWS Web Hosting with Terraform - Cloud Programming Portfolio

Student: Khouloud Chebboubi  
Matriculation: 102303255  
Course:  Cloud Programming (DLBSEPCP01_E)  
University:  IU International University  
Date:  January 2026

 Project Overview
This Terraform project deploys a highly available, scalable website on AWS. The architecture follows cloud best practices for high availability, security, and cost optimization.

 Architecture Components
- **Amazon S3**: Static website hosting (HTML/CSS/JS)
- **Amazon CloudFront**: Global CDN for low latency
- **Application Load Balancer**: Traffic distribution across EC2 instances
- **Auto Scaling Group**: Automatic scaling based on traffic
- **Amazon EC2**: Web servers for dynamic content
- **Amazon VPC**: Network isolation with public/private subnets
- **Multi-AZ Deployment**: High availability across availability zones

 Deployment Instructions

 1. Prerequisites
- AWS Account with IAM permissions
- Terraform installed (version >= 1.0)
- AWS CLI configured

 2. Clone Repository
```bash
git clone https://github.com/YOUR-USERNAME/aws-web-hosting-terraform.git
cd aws-web-hosting-terraform
3. Configure Variables
Copy the example variables file and edit with your values:

bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS settings
4. Deploy Infrastructure
bash
terraform init          # Initialize Terraform
terraform plan          # Review deployment plan
terraform apply         # Deploy infrastructure
5. Access Website
After deployment, get your website URL:

bash
terraform output website_url
 Outputs
Website URL: https://[cloudfront-id].cloudfront.net

S3 Bucket: [your-bucket-name]

ALB DNS: [alb-dns-name].elb.amazonaws.com

CloudFront Distribution: [distribution-id]

 Estimated Monthly Cost: ~$12-15
EC2 t3.micro (2 instances): ~$8

S3 Storage: ~$1

CloudFront: ~$2

ALB: ~$2

Data Transfer: ~$1

 Security Features
HTTPS enforcement via CloudFront

Security groups with least privilege

Private subnets for EC2 instances

AWS WAF integration capability

IAM roles with minimum permissions

 Repository Structure
text
aws-web-hosting-terraform/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example variables file
└── README.md                  # This file
🔧 Testing
Terraform Validate: terraform validate

Plan Review: terraform plan

Website Test: Open CloudFront URL in browser

Auto Scaling Test: Use load testing tools

 Cleanup
To remove all resources and avoid AWS charges:

bash
terraform destroy
