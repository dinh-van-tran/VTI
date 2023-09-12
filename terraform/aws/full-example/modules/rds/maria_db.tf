resource "aws_db_instance" "dinhvt-maria" {
  identifier = "dinhvt-maria-db"
  engine     = "mariadb"

  # `aws rds describe-db-engine-versions --default-only --engine postgres`
  engine_version = "10.6.14"

  # Specify the database instance class
  instance_class = "db.t3.micro"

  # Specify the database instance class
  allocated_storage = 20
  storage_type      = "gp2"

  username = "dinhvt"
  password = "password"

  db_subnet_group_name   = aws_db_subnet_group.dinhvt-rds.name
  # vpc_security_group_ids = [aws_security_group.dinhvt-maria.id]

  # For destroy the database instance
  # https://stackoverflow.com/questions/50930470/terraform-error-rds-cluster-finalsnapshotidentifier-is-required-when-a-final-s
  skip_final_snapshot     = true
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "dinhvt-maria-db"
  }
}

# Define access to the database
# resource "aws_security_group" "dinhvt-maria" {
#   name_prefix = "dinhvt-maria-db-sg"

#   ingress {
#     from_port = 3306
#     to_port   = 3306
#     protocol  = "tcp"

#     # Only allow access from the private subnet 1
#     cidr_blocks      = aws_subnet.dinhvt_private_subnet_1.cidr_block
#     ipv6_cidr_blocks = aws_subnet.dinhvt_private_subnet_1.ipv6_cidr_block
#   }

#   tags = {
#     Name = "dinhvt-maria-db-sg"
#   }
# }
