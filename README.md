# AWS Static Website Deployment using Terraform

## Project Overview
This project demonstrates the automated deployment of a highly available and globally accessible static website on Amazon Web Services (AWS).  
The infrastructure is fully provisioned using **Terraform (Infrastructure as Code)** to ensure reproducibility, automation, and best cloud practices.

The solution uses:
- Amazon S3 for static website hosting
- Amazon CloudFront for global content delivery and low latency
- Terraform for automated and repeatable infrastructure deployment

---

## Architecture Description
User requests are served through **Amazon CloudFront**, which delivers the website from the nearest edge location worldwide.  
CloudFront retrieves the content from an **Amazon S3 bucket**, where the static website files are stored.  
This architecture ensures:
- High availability
- Automatic scalability
- Low latency for global users
- Cost efficiency using managed AWS services

---

## Prerequisites
Before deploying the infrastructure, make sure the following requirements are met:

- An active AWS account
- Terraform version **1.4 or higher**
- AWS CLI installed
- AWS credentials configured locally

To verify installations:
```bash
terraform -v
aws --version
AWS Credentials Configuration
Terraform requires AWS credentials to create resources.

Configure them by running:

aws configure
You will be prompted to enter:

AWS Access Key ID

AWS Secret Access Key

Default region name: eu-central-1

Default output format: press Enter

Deployment Instructions
Follow these steps to deploy the infrastructure:

git clone https://github.com/YOUR_USERNAME/aws-static-website-terraform.git
cd aws-static-website-terraform/terraform
terraform init
terraform plan
terraform apply
When prompted, type:

yes
Terraform will automatically create all required AWS resources.

Accessing the Website
After a successful deployment, Terraform outputs a CloudFront URL.

Example:

cloudfront_url = d123example.cloudfront.net
Open this URL in your browser to view the deployed website.

Infrastructure Teardown
To remove all created AWS resources and avoid unnecessary costs, run:

terraform destroy
Confirm the action by typing:

yes
Project Structure
aws-static-website-terraform/
├── terraform/
│   ├── provider.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── s3.tf
│   ├── upload.tf
│   ├── cloudfront.tf
│   ├── outputs.tf
│
├── website/
│   └── index.html
│
├── README.md
Key Learning Outcomes
Implementation of Infrastructure as Code using Terraform

Deployment of a highly available and globally distributed web architecture

Practical experience with AWS S3 and CloudFront

Automated, reproducible cloud deployments following best practices

Author
Khouloud Chebboubi
Cloud Programming Portfolio – IU Internationale Hochschule
