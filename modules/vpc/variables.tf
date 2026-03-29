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