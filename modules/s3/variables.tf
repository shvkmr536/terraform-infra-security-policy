variable "env" {
  description = "The environment name"
  type        = string
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "s3_version" {
  description = "The versioning state of the S3 bucket"
  type        = bool
}