provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  name     = var.env
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "ec2" {
  source        = "../../modules/ec2"
  name          = "${var.env}-instance"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  app_name      = "${var.env}-app"
  env           = var.env
  aws_region    = var.aws_region
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "secure"
  env         = var.env
  s3_version  = var.s3_version
}
