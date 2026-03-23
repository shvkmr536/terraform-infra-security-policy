vpc_cidr = "10.0.0.0/16"

public_subnets = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
}

ami_id       = "ami-02dfbd4ff395f2a1b"
instance_type = "t2.micro"
aws_region    = "us-east-1"
env           = "dev"