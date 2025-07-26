output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "eip_allocation_id" {
  description = "The Elastic IP allocation ID"
  value       = var.create_eip ? aws_eip.eip[0].id : var.eip_allocation_id
}

