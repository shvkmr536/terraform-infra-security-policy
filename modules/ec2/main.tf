resource "aws_instance" "assignment" {
  ami           = var.ami_id
  instance_type = var.instance_type
  region        = var.aws_region


  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    app_name = var.app_name
  })

  tags = {
    Name        = "${var.env}-web-server"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}