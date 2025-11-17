output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.eks_platform.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.eks_platform.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.eks_platform.private_subnet_ids
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks_platform.cluster_name
}

output "cluster_endpoint" {
  description = "API server endpoint."
  value       = module.eks_platform.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for the cluster."
  value       = module.eks_platform.cluster_certificate_authority_data
}

output "node_group_names" {
  description = "Names of the managed node groups."
  value       = module.eks_platform.node_group_names
}

