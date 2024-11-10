output "backup_schedule_rule_name" {
  value = aws_cloudwatch_event_rule.backup_schedule.name
}
