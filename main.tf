terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  tags = {
    Name        = "Static Website Bucket"
    Environment = var.environment
    Project     = var.project_name
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

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.static_website]
}

# CORREÇÃO: Usar path correto para os arquivos HTML
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "../website/index.html"
  content_type = "text/html"
  etag         = filemd5("../website/index.html")

  depends_on = [aws_s3_bucket_policy.static_website]
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "../website/error.html"
  content_type = "text/html"
  etag         = filemd5("../website/error.html")

  depends_on = [aws_s3_bucket_policy.static_website]
}