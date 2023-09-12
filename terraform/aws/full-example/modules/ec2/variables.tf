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

variable "instance_ami" {
  type = string
  default = "ami-0df7a207adb9748c7"
}

variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "storage_size" {
  type = number
  default = 64
}
