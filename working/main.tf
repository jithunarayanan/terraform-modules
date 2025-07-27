provider "aws" {
  region = "us-east-1"
  profile = "default"
  
}

module "eks" {
  source        = "/Users/jithu/Desktop/terraform-modules/modules/eks"
  name_prefix   = "k3s"
  cluster_name  = "k3s-cluster"
  k8s_version   = "1.29"
  subnet_ids    = module.k3s_vpc.public_subnet_ids

  node_desired_size    = 1
  node_min_size        = 1
  node_max_size        = 2
  node_instance_types  = ["t3.medium"]
  default_tags = {
    Project = "K3s"
    Owner   = "Jithu"
  }
}
  
  