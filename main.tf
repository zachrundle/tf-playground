module "network" {
  source     = "./modules/network"
  name       = var.name
  create_ngw = false
  vpc_cidr   = "10.0.0.0/16"
}
module "eks" {
  source  = "./modules/eks"
  create_eks = false
  cluster_name    = "${var.name}-cluster"
  cluster_version = "1.30"

  subnet_ids               = module.network.private_subnet_ids
  control_plane_subnet_ids = module.network.private_subnet_ids
}


# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "${var.name}-cluster"
#   cluster_version = "1.30"

#   cluster_endpoint_public_access  = true

#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id                   = module.network.vpc
#   subnet_ids               = module.network.private_subnet_ids
#   control_plane_subnet_ids = module.network.private_subnet_ids

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#   }

#   eks_managed_node_groups = {
#     example = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = ["m5.xlarge"]

#       min_size     = 1
#       max_size     = 10
#       desired_size = 1
#     }
#   }

#   # Cluster access entry
#   # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true

#   access_entries = {
#     # One access entry with a policy associated
#     example = {
#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
#           access_scope = {
#             namespaces = ["default"]
#             type       = "namespace"
#           }
#         }
#       }
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }