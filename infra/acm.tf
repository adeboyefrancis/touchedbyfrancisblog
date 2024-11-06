#################################################################
# request public certificates from the amazon certificate manager.
#################################################################


resource "aws_acm_certificate" "acm_certificate" {
  provider = aws.us-east-1
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
###########################
# Fetch Hosted Zone Details
###########################
data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}
#########################################################
# create a record set in route 53 for domain validatation
#########################################################
resource "aws_route53_record" "route53_valid" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
  
}

#############################################
# Route 53 Records for CloudFront Distribution
#############################################

resource "aws_route53_record" "records_for_cf" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.s3_distribution]
}

resource "aws_route53_record" "records_for_cf_www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.s3_distribution]
}

#############################################
# validate acm certificates
#############################################
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn  = aws_acm_certificate.acm_certificate.arn
  provider = aws.us-east-1
  validation_record_fqdns = [for record in aws_route53_record.route53_valid : record.fqdn]

  depends_on = [
    aws_route53_record.route53_valid
  ]

}


