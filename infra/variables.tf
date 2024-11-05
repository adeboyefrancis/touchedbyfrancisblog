# Prefix tagging resources

variable "prefix" {
  description = "Prefix for resources in AWS"
  default     = "tchbg"
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "tech-blog"
}

variable "contact" {
  description = "Contact email for tagging resources"
  default     = "adeboye.francis@icloud.com"
}

variable "tech-blog" {
    type = string
    default = "touchedbyfrancis.cloud"
}

variable "region" {
  description = "Primary resource region"
  default = "eu-west-1"

}
variable "s3_name" {
  type = string
  default = "touchedbyfrancis.cloud"
}


provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
}
