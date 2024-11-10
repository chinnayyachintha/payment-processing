# Payment Gateway Processing
# Processes the payment by interacting with the payment processor, then logs transaction data.
# Create a Lambda function for payment processing.
# Grant API Gateway permission to invoke the Lambda function.
# Set environment variables in Lambda to access credentials and configuration data securely.

resource "aws_lambda_function" "payment_processor" {
  function_name    = "${var.payment_gateway_name}-payment-processor"
  handler          = "payment_process.handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda_files/payment_process.zip")
  
  environment {
    variables = {
      AUTH_RESPONSE = aws_secretsmanager_secret.payment_auth_response.id
    }
  }
}


resource "aws_api_gateway_integration" "payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.payment_gateway.id
  resource_id             = aws_api_gateway_resource.payment_request.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.payment_processor.invoke_arn
}

