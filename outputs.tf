output "website_url" {
  description = "URL of the deployed website"
  value       = "https://${module.storage.cloudfront_domain_name}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static content"
  value       = module.storage.s3_bucket_name
}

output "instructions" {
  description = "Deployment instructions"
  value       = <<EOT
  ===============================
  DEPLOYMENT INSTRUCTIONS:
  1. terraform init
  2. terraform plan
  3. terraform apply -auto-approve
  
  Upload website files:
  aws s3 sync ./website s3://${module.storage.s3_bucket_name}
  
  Access website:
  https://${module.storage.cloudfront_domain_name}
  ===============================
  EOT
}
