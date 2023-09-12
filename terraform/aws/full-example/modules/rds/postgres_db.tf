# variable "private_subnet_1_cidr_block" {
#   type = string
# }

resource "aws_db_instance" "dinhvt-postgres" {
  identifier = "dinhvt-postgres-db"
  engine     = "postgres"
  # `aws rds describe-db-engine-versions --default-only --engine postgres`
  engine_version = "15.3"

  # Specify the database instance class
  instance_class = "db.t3.micro"

  # Provisioned storage size in GB
  allocated_storage = 20
  storage_type      = "gp2"

  username = "dinhvt"
  password = "password"

  db_subnet_group_name = aws_db_subnet_group.dinhvt-rds.name

  # Control access to database from a specific security group
  # vpc_security_group_ids = [aws_security_group.dinhvt-postgres.id]

  # For destroy the database instance
  # https://stackoverflow.com/questions/50930470/terraform-error-rds-cluster-finalsnapshotidentifier-is-required-when-a-final-s
  skip_final_snapshot     = true
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name = "dinhvt-postgres-db"
  }
}

# Define access to the database
# resource "aws_security_group" "dinhvt-postgres" {
#   name_prefix = "dinhvt-postgres-db-sg"

#   ingress {
#     from_port        = 5432
#     to_port          = 5432
#     protocol         = "tcp"

#     # Only allow access from the private subnet 1
#     cidr_blocks      = [var.private_subnet_1_cidr_block]
#   }

#   tags = {
#     Name = "dinhvt-postgres-db-sg"
#   }
# }
