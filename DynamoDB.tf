resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST" # Or PROVISIONED for defined capacity

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
