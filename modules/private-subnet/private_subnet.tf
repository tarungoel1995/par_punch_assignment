/**
 * Region
 */
provider "aws" {
  region = var.aws_region
}
/**
 * private subnets
 */
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = element(keys(var.private_subnets), count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
  tags = {
    Name         = format("%s-%s-private-%s-%d", var.name, lookup(var.private_subnets, element(keys(var.private_subnets), count.index)), element(split("-", element(var.availability_zones, count.index)), 2), count.index + 1)
    az           = element(var.availability_zones, count.index)
    role         = lookup(var.private_subnets, element(keys(var.private_subnets), count.index))
    environment  = var.environment
    organization = var.organization
    team_name    = var.team_name
    created_by   = var.created_by
    Type         = "Private"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "aws_eip" "nateip" {
  vpc = true
  tags = {
    "Name" = var.name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = element(split(",", var.public_subnet_ids), 0)
}

/**
 * Route Tables
 */

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  count  = length(var.private_subnets)
  tags = {
    Name         = format("%s-%s-rt-private-%s-%d", var.name, lookup(var.private_subnets, element(keys(var.private_subnets), count.index)), element(split("-", element(var.availability_zones, count.index)), 2), count.index + 1)
    az           = element(var.availability_zones, count.index)
    role         = lookup(var.private_subnets, element(keys(var.private_subnets), count.index))
    environment  = var.environment
    organization = var.organization
    team_name    = var.team_name
    created_by   = var.created_by
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route" "private-nat" {
  count                  = length(var.nat_gateway_map) * length(var.availability_zones)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

output "private_subnet_ids" {
  value = join(",", aws_subnet.private.*.id)
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat.id
}