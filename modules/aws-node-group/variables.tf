variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN used by the node groups."
  type        = string
}

variable "default_subnet_ids" {
  description = "Fallback subnet IDs when a node group does not specify its own."
  type        = list(string)
}

variable "node_groups" {
  description = "Map defining each managed node group."
  type = map(object({
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    disk_size      = optional(number, 20)
    capacity_type  = optional(string, "ON_DEMAND")
    subnet_ids     = optional(list(string))
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    ami_type        = optional(string)
    release_version = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags merged onto each node group."
  type        = map(string)
  default     = {}
}

