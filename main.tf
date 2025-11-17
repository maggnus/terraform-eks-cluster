module "eks_platform" {
  source = "./modules/aws-eks-platform"

  cluster_name                     = var.cluster_name
  cluster_role_name                = var.cluster_role_name
  node_role_name                   = var.node_role_name
  kubernetes_version               = var.kubernetes_version
  cluster_log_types                = var.cluster_log_types
  cluster_addon_config             = var.cluster_addon_config
  vpc_name                         = var.vpc_name
  vpc_cidr                         = var.vpc_cidr
  public_subnet_cidrs              = var.public_subnet_cidrs
  private_subnet_cidrs             = var.private_subnet_cidrs
  enable_nat_gateway               = var.enable_nat_gateway
  single_nat_gateway               = var.single_nat_gateway
  cluster_security_group_id        = var.cluster_security_group_id
  node_group_security_group_ids    = var.node_group_security_group_ids
  endpoint_public_access           = var.endpoint_public_access
  endpoint_private_access          = var.endpoint_private_access
  kms_key_arn                      = var.kms_key_arn
  node_role_additional_policy_arns = var.node_role_additional_policy_arns
  node_groups                      = var.node_groups
  tags                             = var.tags
  public_subnet_tags               = var.public_subnet_tags
  private_subnet_tags              = var.private_subnet_tags
}

