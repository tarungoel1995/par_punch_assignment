resource "helm_release" "application" {
  chart = "../../../charts/dummy"
  namespace  = var.k8s_app_namespace
  name       = var.k8s_app_name
  create_namespace = true

  set {
    name  = "image.repository"
    value = var.image_repo
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "image.command"
    value = var.image_command
  }

  set {
    name  = "image.args"
    value = var.image_args
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.k8s_app_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.application.arn
  }
}