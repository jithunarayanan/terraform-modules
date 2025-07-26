variable "name_prefix" {
  description = "Name prefix for NAT resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the NAT Gateway in (typically a public subnet)"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "create_eip" {
  description = "Whether to create an Elastic IP or use an existing one"
  type        = bool
  default     = true
}

variable "eip_allocation_id" {
  description = "Allocation ID of an existing EIP (required if create_eip is false)"
  type        = string
  default     = ""
}
