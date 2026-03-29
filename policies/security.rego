package terraform

############################################
# Helper: Check if encryption exists for bucket
############################################
has_s3_encryption(bucket_name) if {
  some enc in input.resource_changes
  enc.type == "aws_s3_bucket_server_side_encryption_configuration"
  enc.change.after.bucket == bucket_name
}

############################################
# Helper: Check if versioning is enabled
############################################
has_s3_versioning(bucket_name) if {
  some ver in input.resource_changes
  ver.type == "aws_s3_bucket_versioning"
  ver.change.after.bucket == bucket_name
  ver.change.after.versioning_configuration.status == "Enabled"
}

############################################
# S3: Encryption must exist
############################################
deny contains msg if {
  bucket := input.resource_changes[_]
  bucket.type == "aws_s3_bucket"

  not has_s3_encryption(bucket.change.after.bucket)

  msg := sprintf("S3 bucket '%s' missing encryption configuration", [bucket.change.after.bucket])
}

############################################
# S3: Versioning must be enabled
############################################
deny contains msg if {
  bucket := input.resource_changes[_]
  bucket.type == "aws_s3_bucket"

  not has_s3_versioning(bucket.change.after.bucket)

  msg := sprintf("S3 bucket '%s' must have versioning enabled", [bucket.change.after.bucket])
}

############################################
# S3: Prevent public access
############################################
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"

  resource.change.after.acl == "public-read"

  msg := sprintf("S3 bucket '%s' must not be public", [resource.change.after.bucket])
}

############################################
# IAM: No wildcard actions
############################################
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_iam_policy"

  stmt := resource.change.after.policy.Statement[_]
  stmt.Effect == "Allow"
  stmt.Action == "*"

  msg := sprintf("IAM policy '%s' allows wildcard actions", [resource.address])
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

  msg := sprintf("Resource '%s' missing tag ManagedBy=Terraform", [resource.address])
}

############################################
# EC2: Restrict instance types (allowlist)
############################################

allowed_instance_types := {
  "t2.micro",
  "t2.small",
  "t2.micro",
  "t2.medium"

}
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"

  instance_type := resource.change.after.instance_type

  not allowed_instance_types[instance_type]

  msg := sprintf(
    "EC2 instance type '%s' is not allowed. Allowed types: %v",
    [instance_type, allowed_instance_types]
  )
}

############################################
# EC2: Restrict instance types for non-prod
############################################

#deny contains msg if {
#  resource := input.resource_changes[_]
#  resource.type == "aws_instance"

#  env := resource.change.after.tags.Environment
#  instance_type := resource.change.after.instance_type

#  env == "dev"
#  not startswith(instance_type, "t3")

#  msg := sprintf("Only t3 instances allowed in dev, found '%s'", [instance_type])
#}
