#############################################
# Get current AWS account ID
data "aws_caller_identity" "current" {}
#############################################


#############################################
# Import GitHub Action Role
#############################################
data "aws_iam_role" "existing_role" {
  name = "GithubAction-Deployer"  
}

#############################################
# Update existing Policy for GitHub
##############################################################
resource "aws_iam_role_policy" "s3-sync-flush" {
  name = "S3Bucket-CFDFlush-Policy"
  role = data.aws_iam_role.existing_role.name  

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
            "Sid": "SyncToBucket",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "${aws_s3_bucket.blog-bucket.arn}/*",
                "${aws_s3_bucket.blog-bucket.arn}"
            ]
        },
        {
            "Sid": "FlushCache",
            "Effect": "Allow",
            "Action": "cloudfront:CreateInvalidation",
            "Resource": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
      }
    ]
  })
}
