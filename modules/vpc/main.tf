provider "aws" {
  region = var.aws_region

}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name         = var.name
    environment  = var.environment
    created_by   = var.created_by
    team_name    = var.team_name
    organization = var.organization
  }

  lifecycle {
    ignore_changes = [tags]
  }

}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

