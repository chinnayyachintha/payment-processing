module "api_gateway" {
  source = "./modules/api_gateway"
  payment_gateway_name = var.payment_gateway_name
}

module "dynamodb" {
  source = "./modules/dynamodb"
  transaction_table_name = var.transaction_table_name
  tags = var.tags
}

module "lambda" {
  source = "./modules/lambda"
  payment_gateway_name = var.payment_gateway_name
}

module "s3" {
  source = "./modules/s3"
  backup_bucket_name = var.backup_bucket_name
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  clouddwatch_event_rule_name = var.clouddwatch_event_rule_name
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  payment_gateway_name = var.payment_gateway_name
  auth_token = var.auth_token
  expiration_time = var.expiration_time
}

module "iam_role" {
  source = "./modules/iam_role"
  payment_gateway_name = var.payment_gateway_name
  aws_region = var.aws_region
}
