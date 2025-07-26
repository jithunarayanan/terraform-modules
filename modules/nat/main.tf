resource "aws_eip" "eip" {
  count = var.create_eip ? 1 : 0

  tags = merge(var.default_tags, {
    Name = "${var.name_prefix}-${var.environment}-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  depends_on = [aws_eip.eip]

  allocation_id = var.create_eip ? aws_eip.eip[0].id : var.eip_allocation_id
  subnet_id     = var.subnet_id

  tags = merge(var.default_tags, {
    Name = "${var.name_prefix}-${var.environment}-nat"
  })
}
