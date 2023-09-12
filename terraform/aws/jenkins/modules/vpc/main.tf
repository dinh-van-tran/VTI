variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block of the public subnet"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "jenkins_vpc"
  }
}

resource "aws_internet_gateway" "jenkins_internet_gateway" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins_internet_gateway"
  }
}

resource "aws_subnet" "jenkins_public_subnet" {
  vpc_id            = aws_vpc.jenkins_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "jenkins_public_subnet_1"
  }
}

resource "aws_route_table" "jenkins_public_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_internet_gateway.id
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.jenkins_public_route_table.id
  subnet_id      = aws_subnet.jenkins_public_subnet.id
}
