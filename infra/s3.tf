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
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.blog-bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        }
    ]
}
EOF
}
