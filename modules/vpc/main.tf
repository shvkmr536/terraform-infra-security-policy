resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.name}-public-${each.key}"
  }
}
