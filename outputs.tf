# NETWORK
output "public_subnets" {
  value = module.network.public_subnet_cidr_block
}

output "private_subnets" {
  value = module.network.private_subnet_cidr_block
}

# EKS
output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_creation_time" {
  value = module.eks.cluster_creation_time
}

output "cluster_k8s_version" {
  value = module.eks.cluster_k8s_version
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_status" {
  value = module.eks.cluster_status
}