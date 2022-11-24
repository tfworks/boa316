resource "aws_dynamodb_table" "unicorntracker" {
  name           = "unicorntracker"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UnicornID"

  attribute {
    name = "UnicornID"
    type = "S"
  }

}
