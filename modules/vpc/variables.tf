variable "name_prefix" {}
variable "vpc_cidr" {
    type = string
    default = "10.10.0.0/16"
}

variable "nacl_ingress_rules" {
  description = "List of ingress rules for the NACL"
  type = list(object({
    rule_number = number
    protocol    = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    rule_action = string
  }))
  default = []
}

variable "nacl_egress_rules" {
  description = "List of egress rules for the NACL"
  type = list(object({
    rule_number = number
    protocol    = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    rule_action = string
  }))
  default = []
}

variable "default_tags" {
  type = map(string)
}

variable "public_azs" {
  type = list(string)
}

variable "private_azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "environment" {
  type        = string
  description = "Environment name like dev, prod, test"
}
