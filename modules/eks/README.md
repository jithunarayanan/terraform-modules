# Terraform EKS Module

This module provisions a basic AWS EKS cluster setup with:
- EKS Cluster with IAM roles
- Managed Node Group

## Prerequisites
- Vpc with subnets

## Inputs

| Variable              | Description                               | Default         |
|-----------------------|-------------------------------------------|-----------------|
| `name_prefix`         | Prefix for resource names                 | -               |
| `region`              | AWS region                                | -               |
| `cluster_name`        | Name of the EKS cluster                   | -               |
| `k8s_version`         | Kubernetes version                        | -               |
| `vpc_cidr`            | CIDR block for the VPC                    | -               |
| `node_desired_size`   | Desired size of node group                | `1`             |
| `node_min_size`       | Min size of node group                    | `1`             |
| `node_max_size`       | Max size of node group                    | `1`             |
| `node_instance_types` | List of EC2 instance types                | `["t3.medium"]` |
| `default_tags`        | Map of default tags to apply to resources | `{}`            |

## Outputs

| Output              | Description                     |
|---------------------|---------------------------------|
| `cluster_name`      | Name of the EKS cluster         |
| `cluster_endpoint`  | API endpoint of the EKS cluster |
| `subnet_ids`        | List of subnet IDs              |

## Example Usage

```hcl
module "eks" {
  source        = "git::https://github.com/jithunarayanan/terraform-modules.git//modules/eks"
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
```

