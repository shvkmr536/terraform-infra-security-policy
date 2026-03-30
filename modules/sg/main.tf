resource "aws_security_group" "web_sg" {
  name   = "${var.env}-web-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-web-sg"
    Environment = var.env
    ManagedBy   = var.ManagedBy
  }

  lifecycle {
    create_before_destroy = true
  }
}