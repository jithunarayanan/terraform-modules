output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "private_route_table_ids" {
  description = "List of route table IDs for private subnets"
  value       = [for rt in aws_route_table.private : rt.id]
}

output "network_acl_id" {
  description = "Network ACL ID used by the subnets"
  value       = aws_network_acl.nacl.id
}
