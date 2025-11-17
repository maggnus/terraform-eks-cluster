locals {
  ordered_keys = sort(keys(aws_subnet.this))
}

output "subnet_ids" {
  description = "Ordered list of subnet IDs."
  value       = [for key in local.ordered_keys : aws_subnet.this[key].id]
}

output "subnet_details" {
  description = "Map of subnet metadata keyed by index."
  value = {
    for key in local.ordered_keys :
    key => {
      id                = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
      cidr_block        = aws_subnet.this[key].cidr_block
      map_public_ip     = aws_subnet.this[key].map_public_ip_on_launch
    }
  }
}

