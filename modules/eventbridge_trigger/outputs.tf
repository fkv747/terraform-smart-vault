output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.snapshot_schedule.arn
}
