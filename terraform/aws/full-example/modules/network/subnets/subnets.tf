resource "aws_subnet" "dinhvt_public_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_cidr_block
  availability_zone = var.availability_zone_2

  tags = {
    Name        = "dinhvt_public_subnet"
    Environment = var.environment
  }
}

resource "aws_subnet" "dinhvt_private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_block_1
  availability_zone = var.availability_zone_1

  tags = {
    Name        = "dinhvt_private_subnet_1"
    Environment = var.environment
  }
}

resource "aws_subnet" "dinhvt_private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_block_2
  availability_zone = var.availability_zone_2

  tags = {
    Name        = "dinhvt_private_subnet_2"
    Environment = var.environment
  }
}

resource "aws_subnet" "dinhvt_private_subnet_3" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_block_3
  availability_zone = var.availability_zone_1

  tags = {
    Name        = "dinhvt_private_subnet_3"
    Environment = var.environment
  }
}

resource "aws_subnet" "dinhvt_private_subnet_4" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidr_block_4
  availability_zone = var.availability_zone_2

  tags = {
    Name        = "dinhvt_private_subnet_3"
    Environment = var.environment
  }
}
