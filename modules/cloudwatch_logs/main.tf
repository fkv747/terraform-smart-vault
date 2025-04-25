resource "aws_cloudwatch_log_group" "lambda_snapshot_logs" {
  name              = "/aws/lambda/lambda_snapshot_creator"
  retention_in_days = 14
}

# AWS automatically creates this log group when Lambda runs, but we override it here so we can control retention (default = forever = $$$).