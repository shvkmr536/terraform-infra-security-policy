variable "name" {
  type        = string
  description = "VPC Name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Invalid CIDR block"
  }
}

variable "env" {
  type        = string
  description = "Environment (e.g. dev, staging, prod)"
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to create"
  default     = 1
}

variable "ManagedBy" {
  type        = string
  description = "The entity that manages the resource"
  default     = "Terraform"
}