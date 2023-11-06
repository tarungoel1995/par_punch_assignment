terraform {
  backend "s3" {
    bucket = "par-punch-assignment"
    key    = "assignment/eks/environment1/terraform.tfstate"
    region = "us-east-1"
  }
}

# In case creating of new eks pls update the name at 2 places 

module "eks" {
  source                      = "../../../modules/eks"
  aws_region                  = "us-east-1"
  availability_zones          = ["us-east-1a", "us-east-1b", "us-east-1c"]
  backend_bucket_name_for_vpc = "par-punch-assignment"
  bucket_path_for_vpc         = "assignment/baseinfra/environment1"
  bucket_region               = "us-east-1"
  cluster_name                = "environment1" # provide the same name in backend key property !!!
  k8s_version                 = "1.28"
  on_demand_nodes_group_name  = ["ondemand-nodes-group-1", "ondemand-nodes-group-2", "ondemand-nodes-group-3"]
  node_instance_type          = "t3.micro"
  root_block_size             = "64" #storage
  desired_capacity            = "3"
  max_size                    = "10"
  min_size                    = "1"
  calico_cni_cidr             = "10.244.0.0/16"
}



output "openid_connect_url" {
  value = module.eks.openid_connect_url
}

output "openid_connect_arn" {
  value = module.eks.openid_connect_arn
}