/**
 * variables that will be used while creating infra
 */

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ap-south-1"
}
variable "name" {
  description = "the name of your infra to create, e.g. \"kub-aws\""
}
variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "organization" {
  default = ""
}
variable "private_subnets" {
  description = "List of all internal subnets"
  type        = map(any)
}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(any)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "nat_gateway_map" {
  description = "map components with natgateway based on requirement or not"
  type        = list(any)
  default     = []
}
variable "route_table_ids" {
  description = "map components with vpc endpoint"
  type        = list(any)
  default     = []
}

variable "nat_gateway_ids" {
  description = "list of nat gateway ids"
  default     = ""
}

variable "vpc_id" {
  description = "vpc id in which subnet to create"
}

variable "vpc_cidr" {
  description = "vpc cidr range to restrict traffic to only vpc range"
}

variable "team_name" {
  type        = string
  description = "describe the enviroment name"
  default     = ""
}

variable "created_by" {
  type        = string
  default     = "Terraform"
}

variable "public_subnet_ids" {
  description = "list of public subnet ids"
}

