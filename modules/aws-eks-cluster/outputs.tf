output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate for the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_names" {
  description = "Names of the managed node groups."
  value       = try(module.node_groups.node_group_names, [])
}

