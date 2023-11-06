/**
 * Region
 */
provider "aws" {
  region = var.aws_region
}

/**
 * Public subnet
 */
resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = element(keys(var.public_subnets), count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.public_subnets)
  tags = {
    Name         = format("%s-%s-public-%s-%d", var.name, lookup(var.public_subnets, element(keys(var.public_subnets), count.index)), element(split("-", element(var.availability_zones, count.index)), 2), count.index + 1)
    az           = element(var.availability_zones, count.index)
    role         = lookup(var.public_subnets, element(keys(var.public_subnets), count.index))
    environment  = var.environment
    organization = var.organization
    team_name    = var.team_name
    created_by   = var.created_by
    Type         = "Public"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

/**
 * Gateways
 */
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  # count  = length(var.public_subnets) >= 1 ? 1 : 0
  tags = {
    Name         = format("%s-igw", var.name)
    environment  = var.environment
    organization = var.organization
    team_name    = var.team_name
    created_by   = var.created_by
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

/**
 * Route Tables
 */
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  count  = length(var.public_subnets)
  tags = {
    Name         = format("%s-%s-rt-public-%s-%d", var.name, lookup(var.public_subnets, element(keys(var.public_subnets), count.index)), element(split("-", element(var.availability_zones, count.index)), 2), count.index + 1)
    az           = element(var.availability_zones, count.index)
    role         = lookup(var.public_subnets, element(keys(var.public_subnets), count.index))
    environment  = var.environment
    organization = var.organization
    team_name    = var.team_name
    created_by   = var.created_by
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "aws_route" "public" {
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  count                  = length(var.public_subnets)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

output "public_subnet_ids" {
  value = join(",", aws_subnet.public.*.id)
}

