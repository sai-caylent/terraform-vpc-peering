################################################
# Essential requester variables
################################################
variable "requester_aws_assume_role_arn" {
  type        = string
  description = "Requester AWS Assume Role ARN"
  default     = null
}
variable "requester_region" {
   type        = string
  description = "Requester AWS region"
}
variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID filter"
  default     = ""
}
variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}

################################################
# Required variables accepter
################################################
variable "accepter_aws_assume_role_arn" {
  type        = string
  description = "Accepter AWS Assume Role ARN"
  default     = null
}
variable "accepter_region" {
  type        = string
  description = "Accepter AWS region"
}

variable "accepter_vpc_id" {
  type        = string
  description = "Accepter VPC ID filter"
  default     = ""
}
variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}
variable "tags" {
  type        = map(any)
  description = "The tags map to associate to the resources."
  default     = {}
}
