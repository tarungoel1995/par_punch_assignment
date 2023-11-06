resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster-sg-${var.cluster_name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = {
    Name = format("eks-cluster-sg-%s", var.cluster_name)
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

resource "aws_security_group" "eks_nodes" {
  name        = "eks-node-sg-${var.cluster_name}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  ingress {
    description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  tags = {
    Name                                        = format("eks-node-sg-%s", var.cluster_name)
    format("kubernetes.io/cluster/%s", var.cluster_name) =  "owned"
  }
}
