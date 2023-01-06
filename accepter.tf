# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
  auto_accept               = var.auto_accept

  tags = merge(
    var.tags,
    {
      Side = "Accepter"
      Name = "VPC A to B"
    },
  )
}
resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }
}
# Create a route for accepter subnets
data "aws_route_tables" "accepter" {
  provider = aws.accepter
  filter {
    name = "vpc-id"
    # values = ["vpc-011078d05f2a9cf44"]
    values = [local.accepter_vpc_id]
  }
}
resource "aws_route" "accepter" {
  provider                  = aws.accepter
  count                     = length(data.aws_route_tables.accepter.ids)
  route_table_id            = tolist(data.aws_route_tables.accepter.ids)[count.index]
  destination_cidr_block    = local.requester_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id
}