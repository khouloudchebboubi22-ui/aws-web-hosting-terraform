resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "../website/index.html"
  content_type = "text/html"
}
