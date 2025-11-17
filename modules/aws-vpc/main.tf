resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

module "public_subnets" {
  source = "../aws-subnet"

  name_prefix             = "${var.name}-public"
  vpc_id                  = aws_vpc.this.id
  cidr_blocks             = var.public_subnet_cidrs
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    var.public_subnet_tags,
  )
}

module "private_subnets" {
  source = "../aws-subnet"

  name_prefix             = "${var.name}-private"
  vpc_id                  = aws_vpc.this.id
  cidr_blocks             = var.private_subnet_cidrs
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = false
  tags = merge(
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs)) : 0

  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = module.public_subnets.subnet_ids[var.single_nat_gateway ? 0 : count.index]

  tags = merge(var.tags, { Name = "${var.name}-nat-${count.index}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(module.public_subnets.subnet_ids)

  subnet_id      = module.public_subnets.subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(module.private_subnets.subnet_ids)

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-private-rt-${count.index}" })
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? length(aws_route_table.private) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.single_nat_gateway ? 0 : count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(module.private_subnets.subnet_ids)

  subnet_id      = module.private_subnets.subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

