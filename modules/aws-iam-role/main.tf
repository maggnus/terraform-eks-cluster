locals {
  cluster_role_name = coalesce(var.cluster_role_name, "${var.cluster_name}-cluster-role")
  node_role_name    = coalesce(var.node_role_name, "${var.cluster_name}-node-role")
}

resource "aws_iam_role" "cluster" {
  name = local.cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each = {
    AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    AmazonEKSServicePolicy = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  }

  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node" {
  name = local.node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

locals {
  default_node_policies = {
    AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

resource "aws_iam_role_policy_attachment" "node_default" {
  for_each = local.default_node_policies

  policy_arn = each.value
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_additional" {
  for_each = toset(var.additional_policies)

  policy_arn = each.value
  role       = aws_iam_role.node.name
}

