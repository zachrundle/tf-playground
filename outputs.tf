# NETWORK
output "public_subnets" {
  value = module.network.public_subnet_cidr_block
}

output "private_subnets" {
  value = module.network.private_subnet_cidr_block
}