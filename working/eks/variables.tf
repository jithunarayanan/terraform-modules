variable "region" {}

variable "environment" {
  type        = string
  description = "Environment name like dev, prod, test"
}

variable "name_prefix" {}
variable "cluster_name" {}
variable "k8s_version" {}

variable "subnet_ids" {
  type = list(string)
}

variable "node_desired_size" {
  default = 1
}

variable "node_min_size" {
  default = 1
}

variable "default_tags" {
  type = map(string)
}
variable "node_max_size" {
  default = 1
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_role_policies" {
  type    = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
