module "ec2" {
  source        = "../../modules/ec2"
  aws_region    = var.aws_region
  instance_type = var.instance_type
  ami_id        = "ami-0030e4319cbf4dbf2"
  env           = var.env
}