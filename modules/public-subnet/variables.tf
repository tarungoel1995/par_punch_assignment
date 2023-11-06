# **
#  * variables that will be used while creating infra
# */

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ap-south-1"
}
variable "name" {
  description = "the name of your infra to create, e.g. \"kub-aws\""
}
variable "organization" {
  default = ""
}
variable "public_subnets" {
  description = "List of all external subnets"
  type        = map(any)
}
variable "vpc_id" {
  description = "vpc id in which subnet to create"
}
variable "vpc_cidr" {
  description = "vpc cidr range to restrict traffic to only vpc range"
}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(any)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "environment" {
  type        = string
  description = "describt the enviroment name"
}
variable "team_name" {
  type        = string
  description = "describt the enviroment name"
  default     = ""
}
variable "created_by" {
  type        = string
  default     = "Terraform"
}

