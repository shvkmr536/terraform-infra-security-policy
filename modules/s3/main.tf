# S3 bucket with advanced security configurations

# Random string for bucket suffix
resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

# S3 bucket configuration
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "${var.env}-${var.bucket_name}-${random_string.bucket_suffix.result}"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name        = "${var.env}-secure-bucket"
    Environment = var.env
    ManagedBy   = var.ManagedBy
  }
}

# Public access block configuration
resource "aws_s3_bucket_public_access_block" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning configuration
resource "aws_s3_bucket_versioning" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

//# Logging configuration
//resource "aws_s3_bucket_logging" "secure_bucket" {
//  bucket = aws_s3_bucket.secure_bucket.id
//
//  target_bucket = aws_s3_bucket.log_bucket.id
//  target_prefix = "logs/"
//}
//
//# Lifecycle configuration to manage old versions (example: delete after 90 days)
//resource "aws_s3_bucket_lifecycle_configuration" "secure_bucket" {
//  bucket = aws_s3_bucket.secure_bucket.id
//
//  rule {
//    id     = "delete-old-versions"
//    status = "Enabled"
//
//    noncurrent_version_expiration {
//      noncurrent_days = 90
//    }
//  }
//}
//
//# KMS key for encryption
//resource "aws_kms_key" "s3_key" {
//  description             = "KMS key for S3 bucket encryption"
//  deletion_window_in_days = 10
//  enable_key_rotation     = true
//}
//
//# Log bucket (minimal config)
//resource "aws_s3_bucket" "log_bucket" {
//  bucket = "logs-${var.env}-${random_string.bucket_suffix.result}"
//}
//
//// Public access block for log bucket (optional but recommended)
//resource "aws_s3_bucket_public_access_block" "log_bucket" {
//  bucket = aws_s3_bucket.log_bucket.id
//
//  block_public_acls       = true
//  block_public_policy     = true
//  ignore_public_acls      = true
//  restrict_public_buckets = true
//}
//
//// Notification configuration (example: send notifications to SNS on object creation)
//resource "aws_s3_bucket_notification_configuration" "secure_bucket" {
//  bucket = aws_s3_bucket.secure_bucket.id
//
//  topic {
//    topic_arn = aws_sns_topic.bucket_notification.arn
//    events    = ["s3:ObjectCreated:*"]
//  }
//}
//
//# SNS topic for notifications
//resource "aws_sns_topic" "bucket_notification" {
//  name = "${var.env}-bucket-notifications"
//}
//