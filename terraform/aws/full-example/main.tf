terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  required_version = ">= 1.5.5"
}

provider "aws" {
  region = "ap-southeast-1"

  access_key = ""
  secret_key = ""
  token      = ""
}

module "vpc" {
  source = "./modules/network/vpc"

  environment = local.environment
}

# Provision 5 subnets in 2 availability zones.
# 1. A public subnet in zone 1.
# 2. Sunet private 1 in zone 1.
# 3. Sunet private 2 in zone 2.
# 4. Sunet private 3 in zone 1.
# 5. Sunet private 4 in zone 2.
module "subnets" {
  source = "./modules/network/subnets"

  environment         = local.environment
  availability_zone_1 = "ap-southeast-1a"
  availability_zone_2 = "ap-southeast-1b"
  vpc_id              = module.vpc.vpc_id
}

# Config network rules for internet access.
module "security_groups" {
  source = "./modules/network/security_groups"

  vpc_id = module.vpc.vpc_id
}

# Provision an internet gateway for internet access.
module "internet_gateway" {
  source = "./modules/network/internet_gateway"

  environment      = local.environment
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.subnets.public_subnet_id
}

# Provision a bastion host for admin access
module "ec2" {
  source = "./modules/ec2"

  environment              = local.environment
  availability_zone        = "ap-southeast-1b"
  public_subnet_id         = module.subnets.public_subnet_id
  public_security_group_id = module.security_groups.public_security_group_id
}

# Provision
# 1. An ECS Fargate cluster running a simple nginx container
# 2. A Load Balancer to distribute traffic across the ECS Fargate cluster.
# 3. An IAM role to allow the ECS Fargate cluster to access AWS CloudWatch Logs.
module "ecs" {
  source = "./modules/ecs"

  environment       = local.environment
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security_groups.public_security_group_id
  subnet_id         = module.subnets.private_subnet_1_id
  subnet_ids = [
    module.subnets.private_subnet_3_id,
    module.subnets.private_subnet_4_id,
  ]
}

# Provision relational database service
# 1. A PostgreSQL database
# 2. A MariaDB database
module "rds" {
  source = "./modules/rds"

  subnet_ids = [
    module.subnets.private_subnet_3_id,
    module.subnets.private_subnet_4_id,
  ]
  # private_subnet_3_cidr_block = module.subnets.private_subnet_3_cidr_block
}
