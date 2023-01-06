requester_aws_assume_role_arn             = "arn:aws:iam::131578276461:role/requester-role-vpca"
requester_region                          = "us-east-2"
requester_vpc_id                          = "vpc-0e2008881bf9def09"
requester_allow_remote_vpc_dns_resolution = true


accepter_aws_assume_role_arn             = "arn:aws:iam::931366402038:role/accepter-role-vpcb"
accepter_region                          = "us-east-2"
accepter_vpc_id                          = "vpc-05c291da894b2fe9b"
accepter_allow_remote_vpc_dns_resolution = true

tags = {
  "Project" = "F45"
}

