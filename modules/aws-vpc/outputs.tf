output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC."
}

output "public_subnet_ids" {
  value       = module.public_subnets.subnet_ids
  description = "IDs of the public subnets."
}

output "private_subnet_ids" {
  value       = module.private_subnets.subnet_ids
  description = "IDs of the private subnets."
}

