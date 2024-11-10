output "lambda_exec_role_arn" {
  description = "The ARN of the IAM role used by Lambda function"
  value       = aws_iam_role.lambda_exec_role.arn
}

output "payment_processing_access_policy_arn" {
  description = "The ARN of the IAM policy for payment processing"
  value       = aws_iam_policy.payment_processing_access_policy.arn
}

output "api_gateway_invoke_permission_statement_id" {
  description = "The statement ID for API Gateway invoke permission"
  value       = aws_lambda_permission.api_gateway_invoke_permission.statement_id
}