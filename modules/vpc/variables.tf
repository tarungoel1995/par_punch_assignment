variable "aws_region" {
  type        = string
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "name" {
  type        = string
  description = "VPC Name"
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

variable "organization" {
  default = ""
}

variable "created_by" {
  type        = string
  default     = "Terraform"
}
