# s3_bucket_module.tf

variable "bucket_name" {
  description = "The name of the S3 bucket."
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning."
  default     = "Disabled"
}
