package terraform
############################################################
# EC2 naming convention
############################################################
#deny contains msg if {
#  resource := input.resource_changes[_]
#  resource.type == "aws_instance"
#
#  name := resource.change.after.tags.Name
#  not startswith(name, "dev-")
#
#  msg := sprintf("EC2 name '%s' must start with 'dev-'", [name])
#}


############################################
# EC2 naming convention (env-based prefixes)
############################################

allowed_prefixes := {
  "dev-",
  "sit-",
  "uat-",
  "test-",
  "staging-",
  "prod-"
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"

  name := resource.change.after.tags.Name

  not valid_prefix(name)

  msg := sprintf(
    "EC2 name '%s' must start with one of %v",
    [name, allowed_prefixes]
  )
}

############################################
# Helper: check prefix
############################################
valid_prefix(name) if {
  some prefix in allowed_prefixes
  startswith(name, prefix)
}

############################################################
# S3 bucket naming convention
############################################################
deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"

  name := resource.change.after.bucket
  not startswith(name, "dev-")

  msg := sprintf("S3 bucket '%s' must start with 'dev-'", [name])
}