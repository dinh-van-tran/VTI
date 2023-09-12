terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.1"
    }
  }

  required_version = ">= 1.5.5"
}

# Set the AWS region
provider "aws" {
  region = "ap-southeast-1"

  access_key = "ASIAZJT35OB4RA3JUXQX"
  secret_key = "+3uj+tTO+WiL/RL9T0g1z1liiHUdJt6HuG8vehuc"
  token      = "IQoJb3JpZ2luX2VjEGUaDmFwLXNvdXRoZWFzdC0xIkgwRgIhAKCXxTbFRsmqmydd/SWYj2cEVc62Fml3yBwnsx/xtlDOAiEAjlPhyYcDUFOpZMmZdB+jLpSCsDaS5HQI9mpxweT/EAsq6wEILhAAGgw2MzkxMzYyNjQzMTMiDPe8WgeIeDqzOst/HirIAeza7P158xF8s+MOr+aWUiBVIrtgPoqA9kN+mh9ImSq+IjuVLTH7+QlEC1Makvl1wRkxYXKkp1MSE910MzFYGI4KyjetNhKshWt7ryStzueI+IDVfnVLOqFgYK25cw/hMOPZacsjaDGUVxlS9uzF7CjOVuH5QgWw0mx6v2QQBJs3VNl8wxbc0YO/QuOgCLugJg2jCIvKMflCwnI424Usmicyc75wfaUOugxW11Dv9K4jtaRBXN7XyHieDAz9j6JaMqWygW79AeSMMNibnacGOpcBCZbfh5DhNId+oN+yL7zVnrr5L7MxFNeIzSkJXcfaKSc3KiE7erxckhg8HSIcp9AUJPUCyk3AWFKvJyUI4lLoTGff79bIqCR184tRTy7c2HC4/3neKgxio0aEuDWciiMaoQjdzwBfMWbRe3WhtmsqpChWjPB1Xwa/Vk7lIaW44HdtbKYLSm88PapZNd08NBLjkpD1i3qS3Q=="
}

# Create AWS s3 buckets
resource "aws_s3_bucket" "dinhvt_s3" {
  count = var.is_provision ? length(var.s3_buckets) : 0

  bucket = var.s3_buckets[count.index]

  tags = {
    Name        = var.s3_buckets[count.index]
    Environment = "dev"
  }
}
