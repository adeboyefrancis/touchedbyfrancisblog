resource "aws_s3_bucket" "blog-bucket" {
  bucket = var.tech-blog

  tags = {
    Name = "${local.prefix}-blog-bucket"
  }

}

resource "aws_s3_bucket_acl" "access-block" {
  bucket = aws_s3_bucket.blog-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "blog-static-config" {
  bucket = aws_s3_bucket.blog-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}


resource "aws_s3_bucket_policy" "s3-cf-bucket-policy" {
  bucket = aws_s3_bucket.blog-bucket.id
  policy = file("infra/IAM/s3-bucket-policy.tpl")
}
