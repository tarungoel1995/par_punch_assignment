
resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "environment"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.private.ids


  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }
  launch_template {
   name = aws_launch_template.your_eks_launch_template.name
   version = aws_launch_template.your_eks_launch_template.latest_version
  }

  instance_types = [
    var.node_instance_type
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    null_resource.trigger_aws_node_deletion
  ]
  tags = {
    Name                                            = "environment1"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
  }
}

resource "aws_launch_template" "your_eks_launch_template" {
  name = "your_eks_launch_template"

  vpc_security_group_ids = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  image_id = "ami-0c97930d0d19e564a"
  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
/etc/eks/bootstrap.sh environment1 --use-max-pods false --kubelet-extra-args '--max-pods=110'
--==MYBOUNDARY==--\
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "EKS-MANAGED-NODE"
    }
  }
}