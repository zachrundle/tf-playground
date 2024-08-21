module "network" {
  source     = "./modules/network"
  name       = var.name
  create_ngw = false
  vpc_cidr   = "10.0.0.0/16"
}
module "eks" {
  source          = "./modules/eks"
  create_eks      = false
  cluster_name    = "${var.name}-cluster"
  cluster_version = "1.30"

  subnet_ids               = module.network.private_subnet_ids
  control_plane_subnet_ids = module.network.private_subnet_ids
}

module "permission_sets" {
  source = "./modules/iam_identity_center"

  permission_sets = [
    {
      name                                = "AdministratorAccess",
      description                         = "Allow full access to the account",
      relay_state                         = "",
      session_duration                    = "",
      tags                                = {},
      inline_policy                       = "",
      policy_attachments                  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      customer_managed_policy_attachments = []
  }]
}