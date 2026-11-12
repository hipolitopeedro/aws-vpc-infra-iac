output "vpc_id" {
  description = "ID of the provisioned AWS VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = aws_subnet.private[*].id
}

output "edge_security_group_id" {
  description = "ID of the Edge Security Group"
  value       = aws_security_group.edge_sg.id
}
