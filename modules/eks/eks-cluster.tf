# EKS Cluster Resources
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.k8s_version
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster.id]
    subnet_ids         = data.aws_subnets.private.ids
  }
  enabled_cluster_log_types = var.eks-cw-logging
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = aws_eks_cluster.eks.id
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks-node-group,
    helm_release.cluster_autoscaler
  ]
}


resource "null_resource" "trigger_aws_node_deletion" {
  triggers = {
    cluster_id = aws_eks_cluster.eks.id
  }

  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.aws_region}
kubectl delete daemonset aws-node --namespace kube-system
EOT
  }

  provisioner "local-exec" {
    command = <<EOT
kubectl create -f ${local.abs_apth}/../../calico/tigera-operator.yaml
EOT
  }
}