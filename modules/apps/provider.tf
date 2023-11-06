provider "aws" {
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}