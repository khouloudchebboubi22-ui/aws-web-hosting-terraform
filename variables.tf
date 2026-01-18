variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "bucket_name" {
  description = "S3 bucket name for static website"
  default     = "my-static-website-bucket-2025"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "key_name" {
  description = "SSH key pair name"
  default     = "web-host-key"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  default     = "ami-0dcc0ebde7b2e00db" # Amazon Linux 2 in eu-central-1
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  default     = ""
}

variable "domain_name" {
  description = "Domain name for website"
  default     = "example.com"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    Project     = "AWS-Web-Hosting"
    Environment = "Production"
    Student     = "Khouloud Chebboubi"
    Course      = "Cloud Programming"
  }
}
