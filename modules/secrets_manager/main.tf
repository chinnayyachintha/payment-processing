resource "aws_secretsmanager_secret" "payment_auth_response" {
  name        = "${var.payment_gateway_name}-auth-response"
  description = "Authentication response for secure access"
}

resource "aws_secretsmanager_secret_version" "payment_auth_response_version" {
  secret_id     = aws_secretsmanager_secret.payment_auth_response.id
  secret_string = jsonencode({
    auth_token       = var.auth_token,  # Replace with actual token value
    expiration_time  = var.expiration_time,  # Replace with actual expiration time
  })
}
