output "transaction_table_name" {
  value = aws_dynamodb_table.transaction_data.name
}

output "audit_table_name" {
  value = aws_dynamodb_table.audit_trail.name
}
