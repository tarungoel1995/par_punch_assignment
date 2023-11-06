variable "tcp_ports" {
  default = "default_null"
}

variable "udp_ports" {
  default = "default_null"
}

variable "cidrs" {
  type = list(any)
}

variable "security_group_name" {}

variable "bucket_path_for_vpc" {}
variable "backend_bucket_name_for_vpc" {}
variable "bucket_region" {}
variable "aws_region" {
  description = "resource region"
  type        = string
}
