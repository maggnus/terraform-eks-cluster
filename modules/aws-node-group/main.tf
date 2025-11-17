resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = length(try(each.value.subnet_ids, [])) > 0 ? each.value.subnet_ids : var.default_subnet_ids

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  instance_types       = each.value.instance_types
  capacity_type        = try(each.value.capacity_type, "ON_DEMAND")
  disk_size            = try(each.value.disk_size, 20)
  ami_type             = try(each.value.ami_type, null)
  release_version      = try(each.value.release_version, null)
  force_update_version = true
  labels               = try(each.value.labels, null)

  dynamic "taint" {
    for_each = try(each.value.taints, [])

    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  tags = merge(var.tags, { "eks/node-group" = each.key })
}

