variable "cluster_name" {
  description = "Name for the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version."
  type        = string
  default     = null
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the control plane."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for managed node groups."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the control plane and node groups."
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Existing security group for the control plane."
  type        = string
  default     = null
}

variable "node_security_group_ids" {
  description = "Additional security groups for nodes."
  type        = list(string)
  default     = []
}

variable "endpoint_public_access" {
  description = "Enable public access to the API server."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private access to the API server."
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "Control plane log types."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "KMS key ARN for envelope encryption."
  type        = string
  default     = null
}

variable "node_groups" {
  description = "Map of managed node groups."
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

variable "cluster_addon_config" {
  description = "Map defining cluster add-ons."
  type = map(object({
    version                  = optional(string)
    service_account_role_arn = optional(string)
    configuration_values     = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags added to all resources."
  type        = map(string)
  default     = {}
}

