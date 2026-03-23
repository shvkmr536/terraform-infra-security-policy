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

variable "public_subnets" {
  type        = map(string)
  description = "AZ => CIDR mapping"
}