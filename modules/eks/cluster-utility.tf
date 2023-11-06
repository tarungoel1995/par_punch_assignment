locals {
  abs_apth = abspath(path.module)
}

resource "helm_release" "cluster_autoscaler" {
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks-node-group
    ]
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  name       = "cluster-autoscaler"
  version    = "9.29.4"
  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = var.k8s_service_account_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "kubectl_manifest" "calico-installation" {
  depends_on = [ null_resource.trigger_aws_node_deletion ]
  yaml_body  = <<-EOF
    kind: Installation
    apiVersion: operator.tigera.io/v1
    metadata:
      name: default
    spec:
      kubernetesProvider: EKS
      cni:
        type: Calico
      calicoNetwork:
        bgp: Disabled
        ipPools:
        - cidr: ${var.calico_cni_cidr}
          encapsulation: VXLAN
          natOutgoing: Enabled
          nodeSelector: all()

    EOF
}