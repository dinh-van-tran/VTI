locals {
  environment = terraform.workspace
}

variable "availability_zone" {
  default = "ap-southeast-1a"
}