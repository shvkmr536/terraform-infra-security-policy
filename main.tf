resource "aws_instance" "demo" {
  ami           = "ami-0030e4319cbf4dbf2" # Amazon Linux 2 (us-east-1)
  instance_type = var.instance_type

  tags = {
    Name = "github-oidc-ec2"
    Environment = "Production"                
  }
}