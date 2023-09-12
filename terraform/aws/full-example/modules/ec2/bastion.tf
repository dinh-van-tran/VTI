variable "environment" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "public_security_group_id" {
  type = string
}

resource "aws_instance" "dinhvt_bastion" {
  ami                    = "ami-0df7a207adb9748c7"
  instance_type          = "t2.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_security_group_id]
  # key_name               = var.key_name

  tags = {
    Name        = "dinhvt_bastion"
    Environment = var.environment
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update -y",
  #     "sudo yum install -y awscli",
  #   ]
  # }
}

# Add storage
resource "aws_ebs_volume" "dinhvt_bastion_storage" {
  availability_zone = var.availability_zone
  size              = 64
  type              = "gp2"
}

resource "aws_volume_attachment" "dinhvt_bastion_storage" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.dinhvt_bastion_storage.id
  instance_id = aws_instance.dinhvt_bastion.id
}