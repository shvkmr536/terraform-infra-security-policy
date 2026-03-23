provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  name           = "prod-vpc"
}


module "ec2" {
  source        = "../../modules/ec2"
  name          = "dev-instance"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[0]
  app_name      = "prod-app"
  env           = var.env
  aws_region    = var.aws_region
}