variable "transaction_table_name" {
  type        = string
  description = "Stores details of each transaction, such as amount, status, and user ID."
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}