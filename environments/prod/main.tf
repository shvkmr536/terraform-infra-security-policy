provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source   = "git::https://github.com/shvkmr536/terraform-github-action.git//modules/vpc?ref=v1.0.0"
  name     = var.env
  vpc_cidr = var.vpc_cidr
  env      = var.env
}


module "ec2" {
  //source        = "../../modules/ec2"
  source        = "git::https://github.com/shvkmr536/terraform-github-action.git//modules/ec2?ref=v1.0.0"
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

