# provider.tf file is used to define the provider and region to be used in the terraform code
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

# api_gateway.tf file is used to define the API Gateway resource
variable "payment_gateway_name" {
  type        = string
  description = "API for processing payments"
}

# cloudwatch.tf file is used to define the CloudWatch resource
variable "clouddwatch_event_rule_name" {
  description = "Triggers backup Lambda function every day"
  type        = string
}

# dynamodb.tf file is used to define the DynamoDB resource
variable "transaction_table_name" {
  type        = string
  description = "Stores details of each transaction, such as amount, status, and user ID."
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}

# lambda.tf file is used to define the Lambda resource
# variable "payment_gateway_name" {
#   type        = string
#   description = "API for processing payments"
# }

# s3.tf file is used to define the S3 resource
variable "backup_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for backups"
}

# iam_role.tf file is used to define the IAM role resource
# variable "payment_gateway_name" {
#     description = "The name of the payment gateway"
#     type        = string
# }

# variable "aws_region" {
#   description = "AWS region to deploy resources"
#   type        = string
# }

# secrets_manager.tf file is used to define the Secrets Manager resource
# variable "payment_gateway_name" {
#   type        = string
#   description = "API for processing payments"
# }

variable "auth_token" {
  type        = string
  description = "Authentication token for secure access"
}

variable "expiration_time" {
  type        = string
  description = "Expiration time for the authentication token"
}

