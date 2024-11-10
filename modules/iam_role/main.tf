data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.payment_gateway_name}-lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "payment_processing_access_policy" {
  name   = "${var.payment_gateway_name}-payment-processing-access-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # DynamoDB permissions
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        Resource = [
          aws_dynamodb_table.transaction_data.arn,
          aws_dynamodb_table.audit_trail.arn
        ]
      },

      # S3 permissions for backups
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.backup_bucket.arn}/*"
      },

      # Secrets Manager permissions
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.payment_api_key.arn
      },

      # CloudWatch Logs permissions
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.payment_processor.function_name}*"
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "attach_payment_processing_access_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.payment_processing_access_policy.arn
}

# Allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.payment_processor.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.payment_gateway.execution_arn}/*/*"
}
