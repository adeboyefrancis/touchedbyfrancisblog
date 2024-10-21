locals {
  prefix = "${var.prefix}-${terraform.workspace}" #Dynamic generate strings for workspace
  s3_origin_id = "${var.s3_name}-origin"
  s3_domain_name = "${var.s3_name}.s3-website-${var.region}.amazonaws.com"
}




