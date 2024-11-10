# Stores details of each transaction, such as amount, status, and user ID.
# DynamoDB table with primary keys to store transaction data.
# DynamoDB for Transaction Data

resource "aws_dynamodb_table" "transaction_data" {
  name           = "${var.transaction_table_name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "transaction_id"
  
  attribute {
    name = "transaction_id"
    type = "S"
  }
  
  tags = merge(
    {
      Name = var.transaction_table_name
    },
    var.tags
  )
}

# Audit Trail in DynamoDB
# Tracks access and modifications to transaction records, creating a complete history.
# DynamoDB table or update the existing table schema to record audit entries.

resource "aws_dynamodb_table" "audit_trail" {
  name         = "${var.transaction_table_name}_audit_trail"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "audit_id"
  
  attribute {
    name = "audit_id"
    type = "S"
  }
  
  attribute {
    name = "timestamp"
    type = "N"
  }
  tags = merge(
    {
      Name = "${var.transaction_table_name}_audit_trail"
    },
    var.tags
  )
}
