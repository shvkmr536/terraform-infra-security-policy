provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "git::https://github.com/shvkmr536/terraform-github-action.git//modules/vpc?ref=v1.0.0"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  name           = "prod-vpc"
}


module "ec2" {
  //source        = "../../modules/ec2"
  source        = "git::https://github.com/shvkmr536/terraform-github-action.git//modules/ec2?ref=v1.0.0"
  name          = "prod-instance"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[0]
  app_name      = "prod-app"
  env           = var.env
  aws_region    = var.aws_region
}