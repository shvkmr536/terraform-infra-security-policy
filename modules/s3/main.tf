resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "${var.bucket_name}-${var.env}-${random_string.bucket_suffix.result}"
  tags = {
    Name        = "${var.env}-secure-bucket"
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = var.s3_version ? "Enabled" : "Suspended"
  }
}
