package terraform

############################################
# Helper: Unique resource key
############################################
resource_key(rc) := key if {
  key := sprintf("%s.%s", [rc.module_address, rc.name])
}

############################################
# Helper: Encryption exists
############################################
has_s3_encryption(bucket_rc) if {
  some enc in input.resource_changes
  enc.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource_key(enc) == resource_key(bucket_rc)
  enc.change.actions[_] == "create"
}

has_s3_encryption(bucket_rc) if {
  some enc in input.resource_changes
  enc.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource_key(enc) == resource_key(bucket_rc)
  enc.change.actions[_] == "update"
}

############################################
# Helper: Versioning enabled
############################################
has_s3_versioning(bucket_rc) if {
  some ver in input.resource_changes
  ver.type == "aws_s3_bucket_versioning"
  resource_key(ver) == resource_key(bucket_rc)
  ver.change.after.versioning_configuration[_].status == "Enabled"
  ver.change.actions[_] == "create"
}

has_s3_versioning(bucket_rc) if {
  some ver in input.resource_changes
  ver.type == "aws_s3_bucket_versioning"
  resource_key(ver) == resource_key(bucket_rc)
  ver.change.after.versioning_configuration[_].status == "Enabled"
  ver.change.actions[_] == "update"
}

############################################
# S3: Encryption required
############################################
deny contains msg if {
  bucket := input.resource_changes[_]
  bucket.type == "aws_s3_bucket"
  bucket.change.actions[_] == "create"

  not has_s3_encryption(bucket)

  msg := sprintf(
    "S3 bucket '%s' missing encryption configuration",
    [bucket.change.after.bucket],
  )
}

############################################
# S3: Versioning required
############################################
deny contains msg if {
  bucket := input.resource_changes[_]
  bucket.type == "aws_s3_bucket"
  bucket.change.actions[_] == "create"

  not has_s3_versioning(bucket)

  msg := sprintf(
    "S3 bucket '%s' must have versioning enabled",
    [bucket.change.after.bucket],
  )
}

############################################
# S3: Prevent public access
############################################
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"

  resource.change.after.acl == "public-read"

  msg := sprintf(
    "S3 bucket '%s' must not be public",
    [resource.change.after.bucket],
  )
}