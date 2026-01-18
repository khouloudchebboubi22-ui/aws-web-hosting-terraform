# Route 53 Record for CloudFront
resource "aws_route53_record" "website" {
  count   = var.route53_zone_id != "" ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}

# Optional: Subdomain for load balancer
resource "aws_route53_record" "alb" {
  count   = var.route53_zone_id != "" ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
}
