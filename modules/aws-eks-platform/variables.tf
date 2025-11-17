variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_role_name" {
  description = "Optional override for the EKS cluster IAM role name."
  type        = string
  default     = null
}

variable "node_role_name" {
  description = "Optional override for the EKS node IAM role name."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Kubernetes version for the control plane."
  type        = string
  default     = "1.30"
}

variable "cluster_log_types" {
  description = "List of control plane log types to enable."
  type        = list(string)
  default     = ["api", "audit"]
}

variable "cluster_addon_config" {
  description = "Map of EKS add-ons to configure on the cluster."
  type = map(object({
    version                  = optional(string)
    service_account_role_arn = optional(string)
    configuration_values     = optional(string)
  }))
  default = {}
}

variable "vpc_name" {
  description = "Optional name for the VPC."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create a NAT gateway for private subnet egress."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT gateway (true) or one per AZ."
  type        = bool
  default     = true
}

variable "cluster_security_group_id" {
  description = "Existing security group ID to use for the cluster. If null, one is created."
  type        = string
  default     = null
}

variable "node_group_security_group_ids" {
  description = "Additional security group IDs to attach to node groups."
  type        = list(string)
  default     = []
}

variable "endpoint_public_access" {
  description = "Whether the Kubernetes API server is reachable publicly."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the Kubernetes API server is reachable privately."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for secret encryption. If null, encryption is disabled."
  type        = string
  default     = null
}

variable "node_role_additional_policy_arns" {
  description = "Extra IAM policy ARNs to attach to the node group role."
  type        = list(string)
  default     = []
}

variable "node_groups" {
  description = "Map of managed node group definitions."
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
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for private subnets."
  type        = map(string)
  default     = {}
}

