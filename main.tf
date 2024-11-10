module "api_gateway" {
  source = "./modules/api_gateway"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda" {
  source = "./modules/lambda"
}

module "s3" {
  source = "./modules/s3"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
}

module "iam_role" {
  source = "./modules/iam_role"
}
