variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "availability_zone_1" {
  description = "The availability zone to deploy to"
  type        = string
}

variable "availability_zone_2" {
  description = "The availability zone to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "private_cidr_block_1" {
  description = "The CIDR block for the priavte subnet 1"
  type        = string
  default     = "10.2.2.0/24"
}

variable "private_cidr_block_2" {
  description = "The CIDR block for the priavte subnet 2"
  type        = string
  default     = "10.2.3.0/24"
}

variable "private_cidr_block_3" {
  description = "The CIDR block for the priavte subnet 3"
  type        = string
  default     = "10.2.4.0/24"
}

variable "private_cidr_block_4" {
  description = "The CIDR block for the priavte subnet 4"
  type        = string
  default     = "10.2.5.0/24"
}
