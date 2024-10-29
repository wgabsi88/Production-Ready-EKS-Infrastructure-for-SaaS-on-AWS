terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/EKSClusterRole"
    external_id = "eks"
  }
  default_tags {
    tags = {
      createdby  = "Terraform"
      environment = var.environment
    }
  }
}
