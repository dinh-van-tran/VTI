output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.dinhvt_public_subnet.id
}

output "private_subnet_1_id" {
  description = "ID of the private subnet 1"
  value       = aws_subnet.dinhvt_private_subnet_1.id
}

output "private_subnet_1_cidr_block" {
  description = "CIDR Block of the private subnet 1"
  value       = aws_subnet.dinhvt_private_subnet_1.cidr_block
}

output "private_subnet_2_id" {
  description = "ID of the private subnet 2"
  value       = aws_subnet.dinhvt_private_subnet_2.id
}

output "private_subnet_3_id" {
  description = "ID of the private subnet 3"
  value       = aws_subnet.dinhvt_private_subnet_3.id
}

output "private_subnet_4_id" {
  description = "ID of the private subnet 4"
  value       = aws_subnet.dinhvt_private_subnet_4.id
}