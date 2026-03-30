output "security_group_name" {
  value = aws_security_group.web_sg.name
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}