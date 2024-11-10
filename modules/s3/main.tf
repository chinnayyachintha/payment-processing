resource "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.backup_bucket_name}"
  acl    = "private"
}

resource "aws_lambda_function" "backup_to_s3" {
  function_name = "${var.backup_lambda_name}_backup_to_s3"
  handler       = "backup_to_s3.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda_files/backup_to_s3.zip")
  environment {
    variables = {
      BACKUP_BUCKET_NAME = aws_s3_bucket.backup_bucket.bucket
    }
  }
}
