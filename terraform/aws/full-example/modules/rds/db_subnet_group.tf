# Specify which subnets the database will be deployed to
resource "aws_db_subnet_group" "dinhvt-rds" {
  name        = "dinhvt-rds-db-subnet-group"
  description = "dinhvt-rds DB subnet group"

  subnet_ids = var.subnet_ids
}
