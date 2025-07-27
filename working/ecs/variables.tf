variable "app_name" {}
variable "app_image" {}
variable "app_port" {
  type    = number
  default = 80
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "fargate_cpu" {
  default = "256"
}
variable "fargate_memory" {
  default = "512"
}
variable "cluster_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "desired_count" {
  default = 1
}
variable "load_balancer_enabled" {
  type    = bool
  default = false
}
variable "target_group_arn" {
  default = ""
}
variable "tags" {
  type    = map(string)
  default = {}
}
