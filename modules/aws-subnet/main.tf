locals {
  az_count = length(var.availability_zones)
  cidr_map = {
    for idx, cidr in var.cidr_blocks :
    tostring(idx) => cidr
  }
}

resource "aws_subnet" "this" {
  for_each = local.cidr_map

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[tonumber(each.key) % local.az_count]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${each.key}"
    },
  )

  lifecycle {
    precondition {
      condition     = local.az_count > 0
      error_message = "availability_zones must contain at least one entry."
    }
  }
}

