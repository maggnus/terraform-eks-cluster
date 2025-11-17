variable "name" {
  description = "Name tag for the VPC."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to distribute subnets across."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway if true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Base tags for VPC resources."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags attached to public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags attached to private subnets."
  type        = map(string)
  default     = {}
}

