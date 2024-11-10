# Users initiate payment requests through an interface 
# (e.g., web or mobile app), which is routed to the Payment Gateway API.
# The API then interacts with the Payment Processor to process the payment.
resource "aws_api_gateway_rest_api" "payment_gateway" {
  name        = "${var.payment_gateway_name}"
  description = "API for processing payments"
}

resource "aws_api_gateway_resource" "payment_request" {
  rest_api_id = aws_api_gateway_rest_api.payment_gateway.id
  parent_id   = aws_api_gateway_rest_api.payment_gateway.root_resource_id
  path_part   = "request"
}

