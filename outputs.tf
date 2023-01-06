output "requester_connection_id" {
  value       = join("", aws_vpc_peering_connection.requester.*.id)
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = join("", aws_vpc_peering_connection.requester.*.accept_status)
  description = "Requester VPC peering connection request status"
}

output "accepter_connection_id" {
  value       = join("", aws_vpc_peering_connection_accepter.accepter.*.id)
  description = "Accepter VPC peering connection ID"
}

output "accepter_accept_status" {
  value       = join("", aws_vpc_peering_connection_accepter.accepter.*.accept_status)
  description = "Accepter VPC peering connection request status"
}

# output "accepter_subnet_route_table_map" {
#   value       = local.accepter_aws_rt_map
#   description = "Map of accepter VPC subnet IDs to route table IDs"
# }

