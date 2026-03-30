provider "aws" {
  region = var.aws_region
}

module "vpc" {
  //source        = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/vpc?ref=v1.0.0" //for tag
  source   = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/vpc?ref=main"
  name     = var.env
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "sg" {
  source = "../../modules/sg"
  name   = "${var.env}-sg"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}


module "ec2" {
  //source        = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/ec2?ref=v1.0.0" //for tag
  source            = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/ec2?ref=main"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  app_name          = "${var.env}-app"
  env               = var.env
  security_group_id = module.sg.web_sg_id
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
}

module "s3" {
  //source      = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/s3?ref=v1.0.0" //import module from git tag
  source      = "git::https://github.com/shvkmr536/terraform-infra-security-policy.git//modules/s3?ref=main" //import module from git branch
  bucket_name = "secure"
  env         = var.env
}

