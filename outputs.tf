output "api_gateway_id" {
    value = module.api_gateway.id
}

output "dynamodb_table_name" {
    value = module.dynamodb.table_name
}

output "lambda_function_name" {
    value = module.lambda.function_name
}

output "s3_bucket_name" {
    value = module.s3.bucket_name
}

output "cloudwatch_log_group_name" {
    value = module.cloudwatch.log_group_name
}

output "secrets_manager_secret_arn" {
    value = module.secrets_manager.secret_arn
}

output "iam_role_arn" {
    value = module.iam_role.arn
}