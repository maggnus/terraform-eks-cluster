output "node_group_names" {
  description = "Names of managed node groups."
  value       = [for ng in aws_eks_node_group.this : ng.node_group_name]
}

