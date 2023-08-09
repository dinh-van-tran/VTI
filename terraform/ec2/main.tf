terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Set the AWS region
provider "aws" {
  region   = "ap-southeast-1"
}

resource "aws_instance" "github_runner" {
  # Ubuntu Server 22.04 LTS with SSD Volume Type
  ami           = "ami-0df7a207adb9748c7"
  # Specify the free tier
  instance_type = "t2.micro"

  tags = {
    Name = "GithubRunner"
  }

  # Run commands on the EC2 instance, after it is created
  # **NOTE**: the `user_data` only works on the AWS.
  # For others: https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#passing-data-into-virtual-machines-and-other-compute-resources
  user_data = <<-EOL
  #!/bin/bash -xe

  # Install kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  EOL
}

# Store the ec2 instance for connecting to it later
data "aws_instance" "github_runner" {
  instance_id = aws_instance.github_runner.id
}

# Print the instance id to the command line.
output "instance_id" {
  value = data.aws_instance.github_runner.id
}
