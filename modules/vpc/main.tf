# -----------------------------
# Terraform Module: VPC for K3s (Multi-AZ Support)
# -----------------------------

locals {
  tag_prefix   = "${var.name_prefix}-${var.environment}"
  common_tags  = merge(var.default_tags, {})
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-vpc"
})
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = local.common_tags
}

resource "aws_subnet" "public" {
  count                   = length(var.public_azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.public_azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-public-subnet-${count.index + 1}"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_azs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.private_azs[count.index]

  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-private-subnet-${count.index + 1}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-public-route-table-${count.index + 1}"
})
  
}

resource "aws_route_table" "private" {
  count  = length(var.private_azs)
  vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.this[count.index].id
#   }
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-private-route-table-${count.index + 1}"
})
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-nacl-${count.index + 1}"
  })
}

resource "aws_network_acl_rule" "ingress" {
  count          = length(var.nacl_ingress_rules)
  network_acl_id = aws_network_acl.nacl.id
  egress         = false

  rule_number    = var.nacl_ingress_rules[count.index].rule_number
  protocol       = var.nacl_ingress_rules[count.index].protocol
  cidr_block     = var.nacl_ingress_rules[count.index].cidr_block
  from_port      = var.nacl_ingress_rules[count.index].from_port
  to_port        = var.nacl_ingress_rules[count.index].to_port
  rule_action    = var.nacl_ingress_rules[count.index].rule_action
}

resource "aws_network_acl_rule" "egress" {
  count          = length(var.nacl_egress_rules)
  network_acl_id = aws_network_acl.nacl.id
  egress         = true

  rule_number    = var.nacl_egress_rules[count.index].rule_number
  protocol       = var.nacl_egress_rules[count.index].protocol
  cidr_block     = var.nacl_egress_rules[count.index].cidr_block
  from_port      = var.nacl_egress_rules[count.index].from_port
  to_port        = var.nacl_egress_rules[count.index].to_port
  rule_action    = var.nacl_egress_rules[count.index].rule_action
}

resource "aws_network_acl_association" "public" {
  count           = length(var.public_azs)
  subnet_id       = aws_subnet.public[count.index].id
  network_acl_id  = aws_network_acl.nacl.id
}

resource "aws_network_acl_association" "private" {
  count           = length(var.private_azs)
  subnet_id       = aws_subnet.private[count.index].id
  network_acl_id  = aws_network_acl.nacl.id
}
