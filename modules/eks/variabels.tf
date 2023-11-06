# Variables Configuration

variable "cluster_name" {
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "bucket_region" {
  type        = string
  description = "The AWS Region of VPC bucket"
}

variable "backend_bucket_name_for_vpc" {
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "bucket_path_for_vpc" {
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "availability_zones" {
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  type        = list(any)
  description = "The AWS AZ to deploy EKS"
}

variable "k8s_version" {
  default     = "1.28"
  type        = string
  description = "Required K8s version"
}

variable "eks-cw-logging" {
  default     = []
  type        = list(any)
  description = "Enable EKS CWL for EKS components"
}



# ###########################
# Node groups variables
################################

variable "node_instance_type" {
  default     = "c5a.2xlarge"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "root_block_size" {
  default     = "32"
  type        = string
  description = "Size of the root EBS block device"

}

variable "on_demand_nodes_group_name" {
  default     = ["ondemand-nodes-group-1", "ondemand-nodes-group-2", "ondemand-nodes-group-3"]
  type        = list(any)
  description = "Autoscaling Desired node capacity"
}



variable "desired_capacity" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max_size" {
  default     = 2
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min_size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

# #################
# Auto Scaler Variables 
# ######

# cluster-autoscaler

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

# Helm

variable "helm_chart_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.20.0"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "./charts"
  description = "Helm repository"
}

variable "app_bucket_name" {
  type        = string
  default     = "par-punch-assignment"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}

variable "k8s_namespace_jenkins" {
  type        = string
  default     = "jenkins"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}
variable "k8s_service_account_name" {
  default     = "cluster-autoscaler"
  description = "The k8s cluster-autoscaler service account name"
}

variable "app_namespace" {
  type        = string
  default     = "application"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}

variable "k8s_app_service_account_name" {
  type        = string
  default     = "dummy"
  description = "The k8s cluster-autoscaler service account name"
}

variable "mod_dependency" {
  type        = bool
  default     = false
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}


variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.28.2-eksbuild.2"
    },
    {
      name    = "coredns"
      version = "v1.10.1-eksbuild.5"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.24.1-eksbuild.1"
    }
  ]
}