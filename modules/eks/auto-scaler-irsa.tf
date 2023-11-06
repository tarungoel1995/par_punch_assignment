resource "kubernetes_namespace" "cluster_autoscaler" {
  depends_on = [aws_eks_cluster.eks]
  count      = (var.enabled && var.k8s_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.k8s_namespace
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  depends_on  = [aws_eks_cluster.eks]
  count       = var.enabled ? 1 : 0
  name        = "eks-cluster-autoscaler-${var.cluster_name}"
  path        = "/"
  description = "Policy for cluster-autoscaler service"

  policy = data.aws_iam_policy_document.cluster_autoscaler[0].json
}

resource "aws_iam_role" "cluster_autoscaler" {
  depends_on         = [aws_eks_cluster.eks]
  count              = var.enabled ? 1 : 0
  name               = "eks-cluster-autoscaler-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume[0].json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  depends_on = [aws_eks_cluster.eks]
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.cluster_autoscaler[0].name
  policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
}










































# resource "aws_iam_role_policy" "cluster-autoscaler" {
#   name = "cluster-autoscaler-policy"
#   role = aws_iam_role.clusterautoscaler.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["autoscaling:DescribeAutoScalingGroups",
#                  "autoscaling:DescribeAutoScalingInstances",
#                  "autoscaling:DescribeLaunchConfigurations",
#                  "autoscaling:DescribeTags",
#                  "autoscaling:SetDesiredCapacity",
#                  "autoscaling:TerminateInstanceInAutoScalingGroup",
#                  "ec2:DescribeLaunchTemplateVersions"]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }
# resource "aws_iam_role" "clusterautoscaler" {
#   name = "${var.cluster_name}-cluster-autoscaler"
#   assume_role_policy    = data.aws_iam_policy_document.cluster_autoscaler_assumerole_policy.json
#   tags = merge(
#   module.data-utils.tags,
#   {
#     "Name"     = "${var.cluster_name}-cluster-autoscaler"
#     "function" = "utility"
#   },
#   )
#   force_detach_policies = true
#   # count                 = data.aws_region.current.name == "us-east-1" ? 1 : 0
# }

# # Terraform create service account for IAM role
# resource "kubernetes_service_account" "cluster-autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = format(
#       "arn:aws:iam::%s:role/%s",
#       data.aws_caller_identity.current.account_id,
#       "${var.cluster_name}-cluster-autoscaler",
#       )
#     }
#   }
# }

# # module "iam_assumable_role_admin" {
# #   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
# #   version                       = "3.6.0"
# #   create_role                   = true
# #   role_name                     = "cluster-autoscaler"
# #   provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
# #   role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
# #   oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
# # }

# # resource "aws_iam_policy" "cluster_autoscaler" {
# #   name_prefix = "cluster-autoscaler"
# #   description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
# #   policy      = data.aws_iam_policy_document.cluster_autoscaler.json
# # }

# # data "aws_iam_policy_document" "cluster_autoscaler" {
# #   statement {
# #     sid    = "clusterAutoscalerAll"
# #     effect = "Allow"

# #     actions = [
# #       "autoscaling:DescribeAutoScalingGroups",
# #       "autoscaling:DescribeAutoScalingInstances",
# #       "autoscaling:DescribeLaunchConfigurations",
# #       "autoscaling:DescribeTags",
# #       "ec2:DescribeLaunchTemplateVersions",
# #     ]

# #     resources = ["*"]
# #   }

# #   statement {
# #     sid    = "clusterAutoscalerOwn"
# #     effect = "Allow"

# #     actions = [
# #       "autoscaling:SetDesiredCapacity",
# #       "autoscaling:TerminateInstanceInAutoScalingGroup",
# #       "autoscaling:UpdateAutoScalingGroup",
# #     ]

# #     resources = ["*"]

# #     condition {
# #       test     = "StringEquals"
# #       variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
# #       values   = ["owned"]
# #     }

# #     condition {
# #       test     = "StringEquals"
# #       variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
# #       values   = ["true"]
# #     }
# #   }
# # }