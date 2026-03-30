variable "name" {
  type = string
}

variable "env" {
  description = "Environment for the deployment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to launch resources in"
  type        = string
}

variable "ManagedBy" {
  type        = string
  description = "The entity that manages the resource"
  default     = "Terraform"
}