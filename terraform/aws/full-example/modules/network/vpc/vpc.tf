resource "aws_vpc" "dinhvt_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name        = "dinhvt_vpc"
    Environment = var.environment
  }
}
