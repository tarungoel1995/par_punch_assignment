provider "aws" {
  region = var.aws_region
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks-cluster-auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks-cluster-auth.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  }
}


provider "null" {
  # Configuration options
}

provider "kubectl" {
  host                   = aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks-cluster-auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
}