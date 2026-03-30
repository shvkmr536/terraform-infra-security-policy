output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

output "instance_name" {
  value = module.ec2.instance_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "web_sg_id" {
  value = module.sg.web_sg_id
}

output "bucket_id" {
  value = module.s3.bucket_id
}

output "security_group_name" {
  value = module.sg.security_group_name
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}