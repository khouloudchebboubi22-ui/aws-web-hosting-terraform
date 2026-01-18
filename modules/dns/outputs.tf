output "website_fqdn" {
  description = "Fully qualified domain name of website"
  value       = var.route53_zone_id != "" ? var.domain_name : var.cloudfront_domain_name
}
