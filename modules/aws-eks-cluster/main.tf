data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

locals {
  create_cluster_security_group = var.cluster_security_group_id == null
}

module "cluster_security_group" {
  count  = local.create_cluster_security_group ? 1 : 0
  source = "../aws-security-group"

  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = data.aws_subnet.selected.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_name}-cluster-sg" })

  ingress_rules = [
    {
      description       = "Allow public HTTPS to control plane"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_group_id = null
      prefix_list_ids   = []
    }
  ]

  egress_rules = [
    {
      description       = "Allow all egress"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_group_id = null
      prefix_list_ids   = []
    }
  ]
}

locals {
  cluster_security_group_id    = local.create_cluster_security_group ? module.cluster_security_group[0].security_group_id : var.cluster_security_group_id
  effective_security_group_ids = distinct(concat([local.cluster_security_group_id], var.node_security_group_ids))
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = local.effective_security_group_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
  }

  enabled_cluster_log_types = var.cluster_log_types

  dynamic "encryption_config" {
    for_each = var.kms_key_arn == null ? [] : [var.kms_key_arn]

    content {
      provider {
        key_arn = encryption_config.value
      }
      resources = ["secrets"]
    }
  }

  depends_on = [aws_cloudwatch_log_group.cluster]

  tags = var.tags
}

module "node_groups" {
  source = "../aws-node-group"

  cluster_name       = aws_eks_cluster.this.name
  node_role_arn      = var.node_role_arn
  default_subnet_ids = var.subnet_ids
  node_groups        = var.node_groups
  tags               = var.tags
}

resource "aws_eks_addon" "this" {
  for_each = var.cluster_addon_config

  cluster_name             = aws_eks_cluster.this.name
  addon_name               = each.key
  addon_version            = try(each.value.version, null)
  service_account_role_arn = try(each.value.service_account_role_arn, null)
  configuration_values     = try(each.value.configuration_values, null)
}

