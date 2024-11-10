variable "payment_gateway_name" {
  type        = string
  description = "API for processing payments"
}

variable "auth_token" {
  type        = string
  description = "Authentication token for secure access"
}

variable "expiration_time" {
  type        = string
  description = "Expiration time for the authentication token"
}