output "instance_id" {
  value = aws_instance.assignment.id
}
output "instance_name" {
  value = aws_instance.assignment.tags["Name"]
}