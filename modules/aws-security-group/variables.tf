variable "name" {
  description = "Name of the security group."
  type        = string
}

variable "description" {
  description = "Description of the security group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the security group belongs to."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the security group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "List of ingress rule definitions."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_group_id = optional(string)
    prefix_list_ids   = optional(list(string), [])
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rule definitions."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_group_id = optional(string)
    prefix_list_ids   = optional(list(string), [])
  }))
  default = []
}

