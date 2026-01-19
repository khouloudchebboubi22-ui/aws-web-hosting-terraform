# AWS Web Hosting with Terraform

This project deploys a highly available, scalable web hosting architecture on AWS using Terraform.

## Architecture Overview

The solution includes:
- **VPC** with public and private subnets across 3 availability zones
- **S3 Bucket** for static content hosting
- **CloudFront CDN** for global content delivery
- **EC2 Instances** in an Auto Scaling Group for dynamic content
- **Application Load Balancer** for traffic distribution
- **Security Groups** and **WAF** for security
- **Route 53** for DNS (optional)

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **Terraform** (version >= 1.0) installed
4. **Git** for cloning the repository

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/khouloudchebboubi22-ui/aws-web-hosting-terraform.git
cd aws-web-hosting-terraform
2. Configure AWS Credentials
bash
aws configure
# Enter your AWS Access Key, Secret Key, region (eu-central-1), and output format (json)
3. Create EC2 Key Pair (Optional but Recommended)
bash
# Create a key pair in AWS console or using AWS CLI
aws ec2 create-key-pair --key-name web-hosting-key --query 'KeyMaterial' --output text > web-hosting-key.pem
chmod 400 web-hosting-key.pem
4. Initialize Terraform
bash
terraform init
5. Review the Plan
bash
terraform plan
6. Apply the Infrastructure
bash
terraform apply -auto-approve
7. Test the Deployment
Check the outputs for the CloudFront URL:

bash
terraform output website_url
Upload test files to S3 bucket:

bash
aws s3 cp ./test-files/index.html s3://$(terraform output -raw s3_bucket_name)/
Visit the website URL in your browser

Testing Guide for Tutor
1. Basic Functionality Test
Visit the CloudFront URL from outputs

Verify static content is served (e.g., /static/style.css)

Verify dynamic content routes to EC2 (any other path)

2. Auto Scaling Test
Generate load using a tool like ab (Apache Bench):

bash
ab -n 1000 -c 50 $(terraform output -raw website_url)/
Check AWS Console → EC2 → Auto Scaling Groups

Verify new instances are launched when CPU exceeds 70%

3. High Availability Test
Manually terminate one EC2 instance via AWS Console

Verify ALB health checks detect the failure

Verify Auto Scaling launches a replacement instance

4. Cleanup Test
bash
terraform destroy -auto-approve
Project Structure
text
aws-web-hosting-terraform/
├── modules/           # Reusable Terraform modules
├── main.tf           # Root configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── terraform.tfvars.example  # Example variables
├── README.md         # This file
└── .gitignore        # Git ignore rules
Cost Estimation
EC2 t3.small: ~$0.0208/hour (~$15/month)

S3 Storage: ~$0.023/GB/month

CloudFront: ~$0.085/GB (first 10TB)

ALB: ~$0.0225/hour (~$16/month)

Data Transfer: Varies by usage

Estimated total: ~$40-60/month for testing

Troubleshooting
Common Issues
Insufficient IAM permissions: Ensure your AWS user has AdministratorAccess or equivalent

Key pair not found: Create the key pair before running terraform apply

S3 bucket name already exists: Change bucket_name in terraform.tfvars

Rate limiting: AWS has limits on new accounts; request limit increases if needed

Debug Commands
bash
# Validate Terraform syntax
terraform validate

# Show current state
terraform show

# Refresh state
terraform refresh

# Check provider version
terraform version
Security Notes
IAM policies follow least privilege principle

Security groups restrict traffic to necessary ports only

S3 buckets have private ACLs with CloudFront OAI access

All data transmission uses HTTPS/TLS 1.2+

Contact
Student: Khouloud Chebboubi

Matriculation: 102303255

Course: Cloud Programming (DLBSEPCP01_E)

Date: January 2026

text

### **2. Module: Network (`modules/network/`)**

**File: `modules/network/main.tf`**
```hcl
# modules/network/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "public"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain = "vpc"
  
  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = {
    Name        = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
  }
  
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id
  }
  
  tags = {
    Name        = "${var.environment}-private-rt-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
