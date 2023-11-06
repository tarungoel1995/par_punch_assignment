data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    region = var.bucket_region
    bucket = var.backend_bucket_name_for_vpc
    key    = format("%s/terraform.tfstate", var.bucket_path_for_vpc)
  }
}