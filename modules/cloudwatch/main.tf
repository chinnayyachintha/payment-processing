# Scheduled Backups with CloudWatch Events
# Automates the backup process by triggering the backup Lambda on a schedule.
#  CloudWatch Event rule to run the backup Lambda at intervals (e.g., daily).

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
