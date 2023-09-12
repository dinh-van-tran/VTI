output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.dinhvt_public_security_group.id
}
