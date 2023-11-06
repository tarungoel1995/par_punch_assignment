resource "aws_ec2_tag" "vpc_tag" {
  resource_id = data.terraform_remote_state.infra.outputs.vpc_id
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}


resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = toset(data.aws_subnets.private.ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}


resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  for_each    = toset(data.aws_subnets.public.ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}


resource "aws_ec2_tag" "public_subnet_tag" {
  for_each    = toset(data.aws_subnets.public.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_tag" {
  for_each    = toset(data.aws_subnets.private.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
