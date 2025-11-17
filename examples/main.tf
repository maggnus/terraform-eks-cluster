
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
  }
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = "../modules/aws-eks-platform"

  cluster_name         = "test-eks"
  kubernetes_version   = "1.33"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnet_cidrs = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]

  node_groups = {
    general = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.small"]
      disk_size      = 50
      labels = {
        workload = "general"
      }
    }
  }

  tags = {
    Environment = "dev"
    Owner       = "examples"
  }
}

