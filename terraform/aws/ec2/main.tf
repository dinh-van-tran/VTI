terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  required_version = ">= 1.5.5"
}

# Set the AWS region
provider "aws" {
  region   = "ap-southeast-1"

  access_key = ""
  secret_key = ""
  token =""
}

resource "aws_instance" "dinhvt_bastion" {
  # Ubuntu Server 22.04 LTS with SSD Volume Type
  ami           = "ami-0df7a207adb9748c7"
  # Specify the free tier
  instance_type = "t2.medium"

  tags = {
    Name = "dinhvt_bastion"
  }

  # Run commands on the EC2 instance, after creating
  # **NOTE**: the `user_data` only works on the AWS.
  # For others: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#passing-data-into-virtual-machines-and-other-compute-resources
  # user_data = <<-EOL
  # #!/bin/bash -xe

  # EOL
}

# load ssh key from file
resource "aws_key_pair" "vti_keypair" {
  key_name   = "vti_keypair"
  public_key = file("${path.module}/vti-keypair.pub")
}

# Add storage
resource "aws_ebs_volume" "dinhvt_bastion_storage" {
  availability_zone = aws_instance.dinhvt_bastion.availability_zone
  size              = 64
  type              = "gp2"
}

resource "aws_volume_attachment" "dinhvt_bastion_storage" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.dinhvt_bastion_storage.id
  instance_id = aws_instance.dinhvt_bastion.id
}

 # Store the ec2 instance for connecting to it later
data "aws_instance" "dinhvt_bastion" {
  instance_id = aws_instance.dinhvt_bastion.id
}

# Print the instance id to the command line.
output "instance_id" {
  value = data.aws_instance.dinhvt_bastion.id
}
