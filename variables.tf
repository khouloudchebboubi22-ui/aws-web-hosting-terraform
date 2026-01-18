variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type = string
  default = "10.0.0.0/16"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type = string
  default = "ami-0dcc0ebde7b2e00db" # Amazon Linux 2 in Frankfurt
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}
