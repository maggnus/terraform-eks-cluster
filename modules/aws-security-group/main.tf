locals {
  ingress_rules = {
    for idx, rule in var.ingress_rules :
    tostring(idx) => rule
  }

  egress_rules = {
    for idx, rule in var.egress_rules :
    tostring(idx) => rule
  }
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress_rules

  type                     = "ingress"
  description              = try(each.value.description, null)
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(try(each.value.cidr_blocks, [])) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks         = length(try(each.value.ipv6_cidr_blocks, [])) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids          = length(try(each.value.prefix_list_ids, [])) > 0 ? each.value.prefix_list_ids : null
  source_security_group_id = try(each.value.security_group_id, null)
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress_rules

  type                     = "egress"
  description              = try(each.value.description, null)
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(try(each.value.cidr_blocks, [])) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks         = length(try(each.value.ipv6_cidr_blocks, [])) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids          = length(try(each.value.prefix_list_ids, [])) > 0 ? each.value.prefix_list_ids : null
  source_security_group_id = try(each.value.security_group_id, null)
  security_group_id        = aws_security_group.this.id
}
