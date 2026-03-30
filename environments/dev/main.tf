provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  name     = var.env
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "sg" {
  source       = "../../modules/sg"
  name         = "${var.env}-sg"
  env          = var.env
  vpc_id       = module.vpc.vpc_id
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "secure"
  env         = var.env
}


module "ec2" {
  source            = "../../modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  app_name          = "${var.env}-app"
  env               = var.env
  security_group_id = module.sg.web_sg_id
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
}