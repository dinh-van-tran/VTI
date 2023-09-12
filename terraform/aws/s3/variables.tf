variable "s3_buckets" {
  type = list(string)
  default = ["dinhvt-bucket1", "dinhvt-bucket2", "dinhvt-bucket3"]
}

variable "is_provision" {
  type = bool
  default = true
}
