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


