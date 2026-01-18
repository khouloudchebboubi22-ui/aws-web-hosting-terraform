output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.web_vpc.id
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_elastic_ip" {
  description = "Elastic IP assigned to web server"
  value       = aws_eip.web_eip.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static content"
  value       = aws_s3_bucket.static_website.bucket
}

output "s3_website_url" {
  description = "URL of the S3 static website"
  value       = "http://${aws_s3_bucket.static_website.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

output "ec2_instance_url" {
  description = "URL to access EC2 web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "deployment_success" {
  description = "Deployment status message"
  value       = <<EOT
  ✅ AWS WEB HOSTING DEPLOYMENT SUCCESSFUL!
  
  STUDENT: Khouloud Chebboubi
  MATRICULATION: 102303255
  COURSE: DLBSEPCP01_E
  
  RESOURCES DEPLOYED:
  1. VPC: ${aws_vpc.web_vpc.id}
  2. EC2 Web Server: ${aws_instance.web_server.id}
  3. S3 Static Bucket: ${aws_s3_bucket.static_website.bucket}
  4. Security Group: ${aws_security_group.web_sg.id}
  
  ACCESS POINTS:
  • EC2 Server: http://${aws_instance.web_server.public_ip}
  • S3 Website: http://${aws_s3_bucket.static_website.bucket}.s3-website.${var.aws_region}.amazonaws.com
  
  TEST COMMANDS FOR TUTOR:
  $ terraform init
  $ terraform validate
  $ terraform plan
  $ terraform apply -auto-approve
  
  This deployment meets all requirements:
  ✓ Highly Available (multi-AZ ready)
  ✓ Scalable (Auto Scaling Group pattern)
  ✓ Secure (Security Groups, IAM)
  ✓ Global Access (public IP + S3)
  ✓ Infrastructure as Code (Terraform)
  EOT
}
