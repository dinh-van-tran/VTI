# Store the ec2 instance for connecting to it later
data "aws_instance" "dinhvt_bastion" {
  instance_id = aws_instance.dinhvt_bastion.id
}

# Print the instance id to the command line.
output "instance_id" {
  value = data.aws_instance.dinhvt_bastion.id
}