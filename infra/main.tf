#############################################
# Terraform Provider Block
#############################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.0"
    }   
  }

#############################################
# Terraform Cloud Backend Configuration
#############################################
  backend "remote" {
    organization = "touchedbyfrancisblog"
    workspaces {
      name = "touchedbyfrancis"
    }
  }
}

#############################################
# AWS Provider Block
#############################################
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Contact     = var.contact
      Environment = terraform.workspace
      ManagedBy   = "Terraform"
    }
  }
}
