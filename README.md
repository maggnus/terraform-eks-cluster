# terraform-eks-cluster

Composable Terraform modules that provision an AWS VPC, IAM roles, and an
Amazon EKS control plane with managed node groups.

## Layout

- `modules/aws-vpc` – opinionated VPC with public/private subnets and optional NAT.
- `modules/aws-iam-role` – IAM roles and policies for the EKS control plane and nodes.
- `modules/aws-subnet` – reusable builder for ordered subnet sets.
- `modules/aws-security-group` – reusable security group with declarative rules.
- `modules/aws-node-group` – managed node group factory for EKS clusters.
- `modules/aws-eks-cluster` – EKS control plane, managed node groups, and optional add-ons.
- `examples/main.tf` – reference configuration that wires the modules together.

## Getting Started

1. Copy `examples/main.tf` into your own root module (or run from the example
   directory) and adjust the variable values for your environment.
2. Provide AWS credentials via your preferred method (`AWS_PROFILE`, environment
   variables, SSO, etc.).
3. Run Terraform from the `examples` directory:

   ```bash
   cd examples
   terraform init
   terraform apply
   ```

## Inputs Overview

| Variable | Description |
| --- | --- |
| `cluster_name` | Name given to the EKS control plane and related resources. |
| `vpc_cidr`, `public_subnet_cidrs`, `private_subnet_cidrs` | Network topology passed to the VPC module (AZs are auto-derived). |
| `node_groups` | Map describing each managed node group (size, instance types, labels, etc.). |
| `cluster_addon_config` | Optional map configuring core EKS add-ons. |
| `tags` | Common tags merged onto every resource. |

See `variables.tf` for the full list of supported options.