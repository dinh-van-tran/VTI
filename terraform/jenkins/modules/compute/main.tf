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

resource "aws_instance" "jenkins_server" {
  ami       = data.aws_ami.ubuntu.id

  subnet_id = var.public_subnet
  vpc_security_group_ids = [var.security_group]

  # 2 CPUs, 8GB RAM
  instance_type          = "t2.large"

  # add ssh key for logging into Jenkins server
  key_name               = aws_key_pair.jenkins_keypair.key_name

  # script to install Jenkins
  user_data = file("${path.module}/install_jenkins.sh")

  tags = {
    Name = "jenkins_server"
  }
}

# load ssh key from file
resource "aws_key_pair" "jenkins_keypair" {
  key_name   = "jenkins_keypair"
  public_key = file("${path.module}/jenkins_keypair.pub")
}

resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins_server.id

  tags = {
    Name = "jenkins_eip"
  }
}
