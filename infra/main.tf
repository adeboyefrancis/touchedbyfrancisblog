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

}

##############################################
# Terraform Cloud Remote Backend Configuration
##############################################
terraform { 
  cloud { 
    
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
  region  = "eu-west-1"
  alias = "eu-west-1"

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
