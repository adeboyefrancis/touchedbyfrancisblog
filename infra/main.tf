#####################
# AWS Cloud Provider
#####################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.0"
    }   
  }

  required_version = ">= 1.2.0"
}

##############################################
# Terraform Cloud Remote Backend Configuration
##############################################

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "touchedbyfrancisblog"

    workspaces {
      name = "touchedbyfrancis"
    }
  }
}

##############################################
# Resource Tagging
##############################################
provider "aws" {
  region  = "${var.region}"

  default_tags {
    tags = {
      
      Project     = var.project
      Contact     = var.contact
      Environment = terraform.workspace
      ManageBy    = "Terraform/deploy"
    }
  }
}

data "aws_region" "current" {} #import data from aws
