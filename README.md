# Terraform Modules for AWS Deployments

This repository contains reusable and customizable **Terraform modules** for deploying secure and scalable AWS infrastructure. These modules are production-ready and designed with flexibility to support various environments and use cases (dev, staging, prod).


## Features

- Custom VPC creation with DNS support and hostname resolution
- Multi-AZ public and private subnets
- Optional NAT Gateways and Elastic IPs
- Internet Gateway and Route Table associations
- Configurable Network ACLs
- Environment-based resource tagging
- Modular and reusable code structure

---

## Module Structure

- `modules/vpc/` – Complete VPC module with subnets, routing, NATs, and NACLs
- Additional modules can be added for compute, RDS, S3, etc.

---

## Usage

### Prerequisites

- [Terraform](https://www.terraform.io/downloads)
- AWS credentials configured (via environment or `~/.aws/credentials`)

---

### Example: Root `main.tf`

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "k3s_vpc" {
  source = "git::https://github.com/jithunarayanan/terraform-modules.git//modules/vpc"

  name_prefix           = "k3s"
  environment           = "dev"
  vpc_cidr              = "10.10.0.0/16"
  public_azs            = ["us-east-1a", "us-east-1b"]
  private_azs           = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs  = ["10.10.3.0/24", "10.10.4.0/24"]
  default_tags = {
    Project = "K3s"
    Owner   = "Jithu"
  }

  nacl_ingress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
      rule_action = "allow"
    }
  ]

  nacl_egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
      rule_action = "allow"
    }
  ]
}


output "vpc_id" {
  value = module.k3s_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.k3s_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.k3s_vpc.private_subnet_ids  
}

```
## Tags Example
Each resource is tagged like:

Name = k3s-dev-vpc
Name = k3s-dev-public-subnet-1
Name = k3s-dev-nacl

## To Deploy
```
terraform init
terraform apply
```
## To Destroy
```
terraform destroy
```
