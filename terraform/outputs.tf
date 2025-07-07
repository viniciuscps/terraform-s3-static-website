# outputs.tf
output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.static_website.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.static_website.arn
}

output "website_endpoint" {
  description = "Endpoint do site estático"
  value       = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "website_domain" {
  description = "Domínio do site estático"
  value       = aws_s3_bucket_website_configuration.static_website.website_domain
}

output "website_url" {
  description = "URL completa do site estático"
  value       = "http://${aws_s3_bucket_website_configuration.static_website.website_endpoint}"
}