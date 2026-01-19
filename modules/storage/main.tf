# modules/storage/main.tf
resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name
  
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Student     = "Khouloud-Chebboubi"
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

resource "aws_s3_bucket_versioning" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}

data "aws_iam_policy_document" "cloudfront_s3_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_website.arn}/*"]
    
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai]
    }
  }
  
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.static_website.arn]
    
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai]
    }
  }
}

# Upload sample static files
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>AWS Web Hosting - Khouloud Chebboubi</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }
        .header {
            background: #232f3e;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .content {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
        }
        .success {
            color: #2d7d46;
            font-weight: bold;
        }
        .architecture {
            margin-top: 20px;
            padding: 15px;
            background: white;
            border-left: 4px solid #ff9900;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚀 AWS Web Hosting Project</h1>
        <p>Successfully deployed using Terraform</p>
        <p><strong>Student:</strong> Khouloud Chebboubi | <strong>Course:</strong> Cloud Programming</p>
    </div>
    
    <div class="content">
        <h2>✅ Deployment Successful!</h2>
        <p class="success">This static content is served from Amazon S3 via CloudFront CDN.</p>
        
        <div class="architecture">
            <h3>Architecture Components:</h3>
            <ul>
                <li>Amazon S3 for static content</li>
                <li>CloudFront Global CDN</li>
                <li>EC2 Auto Scaling Group</li>
                <li>Application Load Balancer</li>
                <li>Multi-AZ VPC</li>
                <li>Route 53 DNS</li>
            </ul>
        </div>
        
        <h3>Test Links:</h3>
        <p><a href="/static/style.css">Static CSS file</a> - Served directly from S3</p>
        <p><a href="/api/health">Health Check API</a> - Served from EC2 backend</p>
        
        <p><em>Last updated: ${timestamp()}</em></p>
    </div>
</body>
</html>
EOF
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "static/style.css"
  content      = <<EOF
/* Static CSS file - Served from S3 via CloudFront */
body {
    font-family: 'Arial', sans-serif;
    line-height: 1.6;
    color: #333;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

.header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.content {
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.success {
    color: #10b981;
    font-weight: bold;
    padding: 10px;
    background: #d1fae5;
    border-radius: 5px;
    border-left: 4px solid #10b981;
}

.architecture {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 20px;
    margin: 20px 0;
}

.architecture h3 {
    color: #4f46e5;
    margin-top: 0;
}

ul {
    padding-left: 20px;
}

li {
    margin-bottom: 8px;
}

a {
    color: #4f46e5;
    text-decoration: none;
    font-weight: 500;
}

a:hover {
    text-decoration: underline;
}

@media (max-width: 768px) {
    body {
        padding: 10px;
    }
    
    .header, .content {
        padding: 20px;
    }
}
EOF
  content_type = "text/css"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Error - AWS Web Hosting</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            border: 1px solid #e74c3c;
            border-radius: 10px;
            background: #ffeaea;
        }
        h1 {
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>⚠️ 404 - Page Not Found</h1>
        <p>Sorry, the page you're looking for doesn't exist.</p>
        <p><a href="/">Return to Homepage</a></p>
        <p><em>This error page is served from S3 bucket</em></p>
    </div>
</body>
</html>
EOF
  content_type = "text/html"
}
