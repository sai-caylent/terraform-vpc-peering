terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.13.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.1.3"
    }
  }
}
provider "aws" {
  alias  = "requester"
  region = var.requester_region
  assume_role {
    role_arn = var.requester_aws_assume_role_arn
  }
}
provider "aws" {
  alias  = "accepter"
  region = var.accepter_region
  assume_role {
    role_arn = var.accepter_aws_assume_role_arn
  }
}


