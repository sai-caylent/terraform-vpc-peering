# Requester's side of the connection.
resource "aws_vpc_peering_connection" "requester" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = data.aws_vpc.accepter.id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = var.accepter_region
  auto_accept   = false

  # tags = {
  #   Side = "Requester"
  #   Name = "VPC A to B"
  # }
  tags = merge(
    var.tags,
    {
      Side = "Requester"
      Name = "VPC A to B"
    },
  )
}
resource "aws_vpc_peering_connection_options" "requester" {
  # Only provision the options if the accepter side of the peering connection is enabled

  provider = aws.requester
  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = local.active_vpc_peering_connection_id
  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
}
# Create a route for requester subnets
data "aws_route_tables" "requester" {
  provider = aws.requester
  filter {
    name   = "vpc-id"
    values = [local.requester_vpc_id]


  }
}
resource "aws_route" "requester" {
  provider                  = aws.requester
  count                     = length(data.aws_route_tables.requester.ids)
  route_table_id            = tolist(data.aws_route_tables.requester.ids)[count.index]
  destination_cidr_block    = local.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}

