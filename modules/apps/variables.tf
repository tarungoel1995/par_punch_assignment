variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "k8s_app_namespace" {
  type        = string
  default     = "application"
}

variable "k8s_app_name" {
  type        = string
  default     = "dummy"
}

variable "k8s_app_service_account_name" {
  type        = string
  default     = ""
}

variable "image_repo" {
  type        = string
  default     = ""
}
variable "image_tag" {
  type        = string
  default     = ""
}
variable "image_args" {
  type        = string
  default     = ""
}
variable "image_command" {
  type        = string
  default     = ""
}

variable "cluster_name" {
  type        = string
  default     = ""
}

variable "app_bucket_name" {
  type        = string
  default     = ""
}

variable "backend_bucket_name_for_eks" {
  type        = string
  description = "The bucket name to store EKS state file"
}

variable "bucket_region" {
  type        = string
  description = "The AWS Region of VPC bucket"
}

variable "bucket_path_for_eks" {
  type        = string
  description = "The AWS Region to deploy EKS"
}