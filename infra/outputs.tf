output "s3_bucket" {
  value = aws_s3_bucket.blog-bucket.id
}
output "cf_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
output "cf_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
