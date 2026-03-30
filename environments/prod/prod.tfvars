aws_region          = "us-east-1"
instance_type       = "t2.medium"
env                 = "prod"
ami_id              = "ami-0c3389a4fa5bddaad" # Amazon Linux 2 AMI (HVM), SSD Volume Type
vpc_cidr            = "10.0.0.0/16"
public_subnet_count = 1
ManagedBy           = "Terraform"