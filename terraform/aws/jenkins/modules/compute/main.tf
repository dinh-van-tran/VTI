variable "security_group" {
  description = "The security groups assigned to the Jenkins server"
}

variable "public_subnet" {
  description = "The public subnet IDs assigned to the Jenkins server"
}

# Get AMI ID for Ubuntu 20.04
data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical account ID
  owners = ["099720109477"]
}

# load multiple scripts when booting up the instance
data "cloudinit_config" "booting_scripts" {
  part {
    content_type = "text/x-shellscript"
    content = file("${path.module}/install_docker.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = file("${path.module}/install_jenkins.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = file("${path.module}/authorize_docker_for_jenkins.sh")
  }
}

resource "aws_instance" "jenkins_server" {
  ami       = data.aws_ami.ubuntu.id

  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.security_group]

  # 2 CPUs, 8GB RAM
  # others: https://aws.amazon.com/ec2/instance-types/
  instance_type          = "t2.large"

  # add ssh key for logging into Jenkins server
  key_name               = aws_key_pair.jenkins_keypair.key_name

  # Running the scripts when booting up the instance
  user_data = data.cloudinit_config.booting_scripts.rendered

  tags = {
    Name = "jenkins_server"
  }
}

# load ssh key from file
resource "aws_key_pair" "jenkins_keypair" {
  key_name   = "jenkins_keypair"
  public_key = file("${path.module}/jenkins_keypair.pub")
}

# Amazon Web Services Elastic IP (EIP) for obtaining a public static IP address for the Jenkins server.
resource "aws_eip" "jenkins_public_ip" {
  instance = aws_instance.jenkins_server.id

  tags = {
    Name = "jenkins_public_ip"
  }
}
