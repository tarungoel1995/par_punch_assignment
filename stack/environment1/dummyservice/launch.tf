# main.tf

terraform {
  backend "s3" {
    bucket = "par-punch-assignment"
    key    = "assignment/eks/environment1/app/terraform.tfstate"
    region = "us-east-1"
  }
}

module "app_s3_bucket" {
  source = "../../../modules/s3" # Replace with the correct path to your module
  bucket_name = "punc-par-assignment-app"
  enable_versioning = "Disabled"
}


module "dummy_service" {
  source = "../../../modules/apps" # Replace with the correct path to your module
  k8s_app_namespace = "application"
  k8s_app_name = "dummy"
  image_repo = "amazon/aws-cli"
  image_tag = "2.13.32"
  image_command = "sleep"
  image_args = "infinity"
  cluster_name = "assignment"
  app_bucket_name = module.app_s3_bucket.s3_bucket_name
  backend_bucket_name_for_eks = "par-punch-assignment"
  bucket_path_for_eks        = "assignment/eks/environment1"
  bucket_region               = "us-east-1"
}
