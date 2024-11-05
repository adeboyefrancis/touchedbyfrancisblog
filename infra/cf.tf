
resource "aws_cloudfront_distribution" "s3_distribution" {
    depends_on = [ aws_s3_bucket.blog-bucket ]
  origin {
    domain_name              = aws_s3_bucket.blog-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac-s3.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["touchedbyfrancis.cloud"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

  function_association {
    event_type = "viewer-request"
    function_arn = aws_cloudfront_function.cf_function.arn
  }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    
    }
  }

  

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

    tags = {
    Name = "${local.prefix}-cf"
  }

  

}

resource "aws_cloudfront_origin_access_control" "oac-s3" {
  name                              = aws_s3_bucket.blog-bucket.id
  description                       = "OAC Prevent direct access to S3 Bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_function" "cf_function" {
  name    = "cf_func"
  runtime = "cloudfront-js-2.0"
  comment = "redirect incoming traffic to index.html"
  publish = true
  code    = file("code/cf_function.js")
}
