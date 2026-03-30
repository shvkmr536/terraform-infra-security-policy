resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
    ManagedBy   = var.ManagedBy
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name        = "${var.env}-public-subnet-${count.index}"
    Environment = var.env
    ManagedBy   = var.ManagedBy
  }
}