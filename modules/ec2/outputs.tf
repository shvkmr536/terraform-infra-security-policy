output "instance_id" {
  value = aws_instance.assignment.id
}
output "instance_name" {
  value = aws_instance.assignment.tags["Name"]
}

output "instance_public_ip" {
  value = aws_instance.assignment.public_ip
}