variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_role_name" {
  description = "Optional IAM role name for the cluster."
  type        = string
  default     = null
}

variable "node_role_name" {
  description = "Optional IAM role name for managed node groups."
  type        = string
  default     = null
}

variable "additional_policies" {
  description = "Extra policy ARNs to attach to the node role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}

