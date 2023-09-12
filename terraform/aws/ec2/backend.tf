terraform {
  cloud {
    organization = "dinhtran"

    workspaces {
      name = "bastion"
    }
  }
}