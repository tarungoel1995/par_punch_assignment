data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    region = var.bucket_region
    bucket = var.backend_bucket_name_for_vpc
    key    = format("%s/terraform.tfstate", var.bucket_path_for_vpc)
  }
}

data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [data.terraform_remote_state.infra.outputs.vpc_id]
  }

  tags = {
    Type = "Private"
  }
}

data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [data.terraform_remote_state.infra.outputs.vpc_id]
  }

  tags = {
    Type = "Public"
  }
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = aws_eks_cluster.eks.name
}


### iam ###
# Policy
data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  statement {
    sid = "Autoscaling"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = [
      "*",
    ]

    effect = "Allow"
  }

}

# Role
data "aws_iam_policy_document" "cluster_autoscaler_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.iam.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}
