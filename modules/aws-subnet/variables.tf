variable "name_prefix" {
  description = "Prefix for naming the subnets."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to place the subnets in."
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to spread the subnets across."
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in these subnets receive public IPs."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to each subnet."
  type        = map(string)
  default     = {}
}

