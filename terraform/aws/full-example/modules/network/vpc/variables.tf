variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "cidr_block" {
  description = "value of cidr block"
  type        = string
  default     = "10.2.0.0/16"
}
