terraform {
  cloud {
    organization = "dinhtran"

    workspaces {
      name = "s3"
    }
  }
}