variable "name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
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

variable "subnet_id" {
  type = string
}


