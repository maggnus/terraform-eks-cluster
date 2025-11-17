locals {
  base_tags = merge(
    {
      Project   = var.cluster_name
      ManagedBy = "terraform"
    },
    var.tags,
  )

  cluster_shared_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = merge(
    local.cluster_shared_subnet_tags,
    {
      "kubernetes.io/role/elb" = "1"
    },
    var.public_subnet_tags,
  )

  private_subnet_tags = merge(
    local.cluster_shared_subnet_tags,
    {
      "kubernetes.io/role/internal-elb" = "1"
    },
    var.private_subnet_tags,
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

module "vpc" {
  source = "../aws-vpc"

  name                 = coalesce(var.vpc_name, "${var.cluster_name}-vpc")
  cidr_block           = var.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags                = local.base_tags
  public_subnet_tags  = local.public_subnet_tags
  private_subnet_tags = local.private_subnet_tags
}

module "iam" {
  source = "../aws-iam-role"

  cluster_name        = var.cluster_name
  cluster_role_name   = var.cluster_role_name
  node_role_name      = var.node_role_name
  additional_policies = var.node_role_additional_policy_arns
  tags                = local.base_tags
}

module "eks" {
  source = "../aws-eks-cluster"

  cluster_name              = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = module.vpc.private_subnet_ids
  cluster_role_arn          = module.iam.cluster_role_arn
  node_role_arn             = module.iam.node_role_arn
  cluster_security_group_id = var.cluster_security_group_id
  node_security_group_ids   = var.node_group_security_group_ids
  endpoint_public_access    = var.endpoint_public_access
  endpoint_private_access   = var.endpoint_private_access
  cluster_log_types         = var.cluster_log_types
  kms_key_arn               = var.kms_key_arn
  node_groups               = var.node_groups
  cluster_addon_config      = var.cluster_addon_config
  tags                      = local.base_tags
}

