# resource "aws_eks_cluster" "this" {
#   count = var.create_eks ? 1 : 0

#   name                          = var.cluster_name
#   role_arn                      = local.cluster_role
#   version                       = var.cluster_version
#   enabled_cluster_log_types     = var.cluster_enabled_log_types
#   bootstrap_self_managed_addons = var.bootstrap_self_managed_addons

#   vpc_config {
#     security_group_ids      = compact(distinct(concat(var.cluster_additional_security_group_ids, [local.cluster_security_group_id])))
#     subnet_ids              = coalescelist(var.control_plane_subnet_ids, var.subnet_ids)
#     endpoint_private_access = var.cluster_endpoint_private_access
#     endpoint_public_access  = var.cluster_endpoint_public_access
#     public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
#   }
# }