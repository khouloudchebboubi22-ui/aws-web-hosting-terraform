# modules/cdn/main.tf
resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront for web hosting - Khouloud Chebboubi"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"  # US, Canada, Europe
  
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    origin_id   = "S3Origin"
    
    s3_origin_config {
      origin_access_identity = var.cloudfront_oai_id
    }
  }
  
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "ALBOrigin"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  default_cache_behavior {
    target_origin_id = "ALBOrigin"
    
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    
    forwarded_values {
      query_string = true
      headers      = ["*"]
      
      cookies {
        forward = "all"
      }
    }
    
    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 3600
    viewer_protocol_policy = "redirect-to-https"
  }
  
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    target_origin_id = "S3Origin"
    
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    
    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl     = 0
    default_ttl = 86400  # 24 hours
    max_ttl     = 86400
    viewer_protocol_policy = "redirect-to-https"
  }
  
  ordered_cache_behavior {
    path_pattern     = "*.html"
    target_origin_id = "S3Origin"
    
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    
    forwarded_values {
      query_string = false
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl     = 0
    default_ttl = 3600  # 1 hour
    max_ttl     = 86400
    viewer_protocol_policy = "redirect-to-https"
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
    error_caching_min_ttl = 300
  }
  
  custom_error_response {
    error_code         = 403
    response_code      = 403
    response_page_path = "/error.html"
    error_caching_min_ttl = 300
  }
  
  tags = {
    Name        = "${var.environment}-cloudfront-distribution"
    Environment = var.environment
    Student     = "Khouloud-Chebboubi"
  }
}
