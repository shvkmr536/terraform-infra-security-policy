variable "app_name" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "env" {
  description = "Environment for the deployment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to launch resources in"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to associate with the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance in"
  type        = string
}

variable "ManagedBy" {
  type        = string
  description = "The entity that manages the resource"
  default     = "Terraform"
}
