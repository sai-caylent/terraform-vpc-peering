locals {
  requester_vpc_id     = data.aws_vpc.requester.id
  requester_cidr_block = data.aws_vpc.requester.cidr_block
}


locals {
  accepter_vpc_id                  = data.aws_vpc.accepter.id
  accepter_cidr_block              = data.aws_vpc.accepter.cidr_block
  
  active_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id
}

