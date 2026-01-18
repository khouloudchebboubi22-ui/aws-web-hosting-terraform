terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "AWS-Web-Hosting"
      Student     = "Khouloud Chebboubi"
      Matriculation = "102303255"
      Course      = "DLBSEPCP01_E"
      Environment = var.environment
    }
  }
}

# 1. VPC for Network Isolation
resource "aws_vpc" "web_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "web-hosting-vpc-${var.environment}"
  }
}

# 2. Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${var.environment}"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_vpc.id
  
  tags = {
    Name = "main-igw-${var.environment}"
  }
}

# 4. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.web_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "public-route-table-${var.environment}"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group for Web
resource "aws_security_group" "web_sg" {
  name        = "web-sg-${var.environment}"
  description = "Allow HTTP/HTTPS traffic"
  vpc_id      = aws_vpc.web_vpc.id
  
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "web-security-group-${var.environment}"
  }
}

# 7. EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
  
  tags = {
    Name = "web-server-${var.environment}"
  }
}

# 8. S3 Bucket for Static Content
resource "aws_s3_bucket" "static_website" {
  bucket = "web-static-${var.environment}-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name = "static-website-bucket-${var.environment}"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  
  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}

# 9. Random ID for bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# 10. Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 11. Elastic IP for static IP
resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
  vpc      = true
  
  tags = {
    Name = "web-server-eip-${var.environment}"
  }
}
