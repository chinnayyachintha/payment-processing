output "payment_api_key_arn" {
    value = aws_secretsmanager_secret.payment_api_key.arn
}

output "payment_api_key_version_id" {
    value = aws_secretsmanager_secret_version.payment_api_key_value.version_id
}