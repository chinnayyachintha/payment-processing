# Scheduled Backups with CloudWatch Events
# Automates the backup process by triggering the backup Lambda on a schedule.
#  CloudWatch Event rule to run the backup Lambda at intervals (e.g., daily).

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
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.backup_lambda_name}_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_event_rule" "backup_schedule" {
  name        = "${var.clouddwatch_event_rule_name}"
  description = "Triggers backup Lambda function every day"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "backup_lambda_target" {
  rule      = aws_cloudwatch_event_rule.backup_schedule.name
  arn       = aws_lambda_function.backup_to_s3.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_backup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backup_to_s3.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.backup_schedule.arn
}
