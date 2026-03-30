package terraform
############################################
# IAM: No wildcard actions
############################################
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_iam_policy"

  stmt := resource.change.after.policy.Statement[_]
  stmt.Effect == "Allow"
  stmt.Action == "*"

  msg := sprintf(
    "IAM policy '%s' allows wildcard actions",
    [resource.address],
  )
}

############################################
# Tagging: ManagedBy must exist
############################################
deny contains msg if {
  resource := input.resource_changes[_]

  resource.type in {
    "aws_instance",
    "aws_s3_bucket",
    "aws_vpc",
    "aws_subnet",
    "aws_security_group",
    "aws_ebs_volume",
    "aws_rds_instance"
  }

  tags := resource.change.after.tags
  not tags.ManagedBy

  msg := sprintf(
    "Resource '%s' missing tag ManagedBy=Terraform",
    [resource.address],
  )
}

############################################
# EC2: Instance type allowlist
############################################
allowed_instance_types := {
  "t2.micro",
  "t2.small",
  "t2.medium"
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"

  instance_type := resource.change.after.instance_type
  not allowed_instance_types[instance_type]

  msg := sprintf(
    "EC2 instance type '%s' is not allowed. Allowed types: %v",
    [instance_type, allowed_instance_types],
  )
}