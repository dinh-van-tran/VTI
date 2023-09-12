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

  access_key = "ASIAZJT35OB4SXTIJQQ4"
  secret_key = "b+YWNxM3VXZrVCovRprwOl35n96yX7IpkGV04eW+"
  token ="IQoJb3JpZ2luX2VjEDcaDmFwLXNvdXRoZWFzdC0xIkcwRQIhAPv8ZpPGtp75SWWL0az5APsIVq5sib8tondlTh5rBKx/AiAW/YTaaaTIXhOK8qBoA5DciJCoRfOvbAjbqtukj9SaOyr0AQjw//////////8BEAAaDDYzOTEzNjI2NDMxMyIMZBejOiayOCyQ7TsPKsgBt697u2OTh2tUAYCrv8NhwO5pu1zUtb/InvvrTiw5GQe8A5gimQAWlNZwsO6IsZ/kiCNYd/7EqsnNMBHi1lk/NOyG9oEQvi4Jurp/5C4RNHBrNsHeIiTYS0GKyFDgPCxKN9USLjAknbFa2RyvD539nL6cTiY5F4Oi01B1Hf5GZop6EhA7P87ExLZf8sHJeLRMBmIp/CxVRIs0EoR7llXiZSSRJEMv5rB7RkcA95emg5/8I1XWpaBPH7XM0x3+awemVKDJGSERzWwwtZOTpwY6mAHhdNRTph3+kF7W7RCER7lee6BnxSozFLYgJ+WsGtNDqbd31LRMZ9KpQ+uyPfu9zDj/MmEQuzflcAWvQSEs8ZAHUW6U4UDirYqWPnAhXUsmVv7EHpmJ2xo+Uz6VQJ8dbKS032T1DnkgTi/Nc4vzBnZXozRnB7vJ1p/cZcu1HHvwBxHUOkEfQbtOw8UfQvIcizzFQMY+0pDvNg=="
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
