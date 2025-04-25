resource "aws_sns_topic" "snapshot_alerts" {
  name = "snapshot-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.snapshot_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
