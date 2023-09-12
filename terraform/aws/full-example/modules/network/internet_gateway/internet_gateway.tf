# Create a gateway for internet access
resource "aws_internet_gateway" "dinhvt_internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "dinhvt_internet_gateway"
    Environment = var.environment
  }
}

# Allowing access from the internet to the public subnet
# There are no access to the private subnets
resource "aws_route_table" "dinhvt_public_access" {
  vpc_id = var.vpc_id

  route {
    # Allowing all traffic from the internet
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dinhvt_internet_gateway.id
  }

  tags = {
    Name        = "dinhvt_public_access"
    Environment = var.environment
  }
}

# Only allow public access to the public subnet
resource "aws_route_table_association" "public_access" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.dinhvt_public_access.id
}
