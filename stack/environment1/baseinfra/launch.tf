terraform {
  backend "s3" {
    bucket = "par-punch-assignment"
    key    = "assignment/baseinfra/environment1/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  aws_region = "us-east-1"
}

module "vpc" {
  aws_region  = local.aws_region
  source      = "../../../modules/vpc"
  name        = "environment1"
  environment = "assignment"
  cidr        = "10.0.0.0/16"
}

module "public_subnet" {
  aws_region         = local.aws_region
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  source             = "../../../modules/public-subnet"
  name               = "assignment"
  environment        = "assignment"
  public_subnets = {
    "10.0.128.0/20" = "external"
    "10.0.144.0/20" = "external"
    "10.0.160.0/20" = "external"
  }
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}

module "private_subnet" {
  aws_region         = local.aws_region
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  source             = "../../../modules/private-subnet"
  name               = "assignment"
  environment        = "assignment"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  public_subnet_ids  = module.public_subnet.public_subnet_ids
  private_subnets = {
    "10.0.192.0/21" = "internal"
    "10.0.200.0/21" = "internal"
    "10.0.208.0/21" = "internal"
  }
  nat_gateway_map = ["internal"]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}