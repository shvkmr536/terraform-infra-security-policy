resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name        = "web-server-${var.env}"
    Environment = var.env
  }
}