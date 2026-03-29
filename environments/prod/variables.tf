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
  description = "The CIDR sblock for the VPC"
  type        = string
}

variable "s3_version" {
  description = "The versioning state of the S3 bucket"
  type        = bool
  default     = true
}