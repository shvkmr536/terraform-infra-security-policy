variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "env" {
  default = "dev"
  type    = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = map(string)
}
