data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    region = var.bucket_region
    bucket = var.backend_bucket_name_for_eks
    key    = format("%s/terraform.tfstate", var.bucket_path_for_eks)
  }
}




data "aws_iam_policy_document" "application" {
  count = var.enabled ? 1 : 0

  statement {
    sid = "Autoscaling"

    actions = [
        "s3:PutObject"
        ]

    resources = [
        "arn:aws:s3:::${var.app_bucket_name}/*"
        ]

    effect = "Allow"
  }

}

# Role
data "aws_iam_policy_document" "application_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.terraform_remote_state.eks.outputs.openid_connect_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.terraform_remote_state.eks.outputs.openid_connect_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_app_namespace}:${var.k8s_app_name}",
      ]
    }

    effect = "Allow"
  }
}