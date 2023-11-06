resource "aws_iam_policy" "application" {
  name        = "${var.cluster_name}-${var.k8s_app_name}"
  path        = "/"
  description = "Policy for ${var.k8s_app_name} service"
  policy = data.aws_iam_policy_document.application[0].json
}

resource "aws_iam_role" "application" {
  name               = "${var.cluster_name}-${var.k8s_app_name}"
  assume_role_policy = data.aws_iam_policy_document.application_assume[0].json
}

resource "aws_iam_role_policy_attachment" "application" {
  role       = aws_iam_role.application.name
  policy_arn = aws_iam_policy.application.arn
}