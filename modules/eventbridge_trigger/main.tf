resource "aws_cloudwatch_event_rule" "snapshot_schedule" {
  name                = "snapshot-daily-schedule"
  description         = "Triggers snapshot Lambda once per day"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.snapshot_schedule.name
  target_id = "LambdaSnapshotTrigger"
  arn       = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.snapshot_schedule.arn
}

