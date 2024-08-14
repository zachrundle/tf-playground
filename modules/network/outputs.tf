output "vpc" {
  value = aws_vpc.this
}

output "private_subnet_ids" {
  value = [for subnet in values(aws_subnet.private_subnet) : subnet.id]
}

output "public_subnet_ids" {
  value = [for subnet in values(aws_subnet.private_subnet) : subnet.id]
}

output "private_subnet_cidr_block" {
  value = [for subnet in values(aws_subnet.private_subnet) : subnet.cidr_block]
}

output "public_subnet_cidr_block" {
  value = [for subnet in values(aws_subnet.public_subnet) : subnet.cidr_block]
}