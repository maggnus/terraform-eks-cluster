output "cluster_role_arn" {
  description = "ARN of the IAM role assumed by the EKS control plane."
  value       = aws_iam_role.cluster.arn
}

output "node_role_arn" {
  description = "ARN of the IAM role assumed by managed node groups."
  value       = aws_iam_role.node.arn
}

