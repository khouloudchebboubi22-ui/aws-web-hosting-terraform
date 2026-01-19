# variables.tf

variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  default     = "my-static-website-bucket-12345"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "key_name" {
  description = "SSH key pair name"
  default     = "my-key-pair"
}

variable "min_size" {
  description = "Min instances in ASG"
  default     = 2
}

variable "max_size" {
  description = "Max instances in ASG"
  default     = 6
}

variable "desired_capacity" {
  description = "Desired instances in ASG"
  default     = 3
}
