# terraform {
#   required_version = ">= 0.14"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.1, < 3.38.0"
#     }
#   }
# }

terraform {
  required_version = ">= 0.14"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}