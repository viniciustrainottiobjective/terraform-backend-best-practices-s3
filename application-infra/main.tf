terraform {
  required_version = "~> 1.2.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }
  }

  backend "s3" { }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  alias   = "us-east-1"
}


module "website" {
  source = "viniciustrainotti/static-website-module/aws"

  aws_profile      = var.aws_profile
  application_name = var.application_name
  website_path     = var.website_path
}
