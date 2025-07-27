locals {
  tag_prefix   = "${var.name_prefix}-${var.environment}"
  common_tags  = merge(var.default_tags, {})
}

resource "aws_iam_role" "eks_cluster_role" {
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-eks-cluster-role"
  })

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks" {
  name = "${local.tag_prefix}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  version = var.k8s_version
  tags = merge(local.common_tags, {
  Name = "${local.tag_prefix}-vpc"
  })

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_iam_role" "node_role" {
  name = "${local.tag_prefix}-node-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  count      = length(var.node_role_policies)
  policy_arn = var.node_role_policies[count.index]
  role       = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.name_prefix}-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.node_instance_types

  depends_on = [aws_iam_role_policy_attachment.node_policies]
}
