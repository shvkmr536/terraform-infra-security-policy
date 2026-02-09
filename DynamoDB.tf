resource "aws_dynamodb_table" "example_table" {
  name         = "example-table"
  billing_mode = "PAY_PER_REQUEST"

  tags = {
    Environment = "Production"
    Project     = "Example"
  }

  point_in_time_recovery_enabled = true

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  hash_key = "id"
}