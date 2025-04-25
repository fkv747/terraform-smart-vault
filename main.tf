resource "aws_s3_bucket" "tfstate" {
  bucket = "kev-backup-tfstate-04242025"
  force_destroy = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

# Lambda Snapshot Module
module "lambda_snapshot" {
  source = "./modules/lambda_snapshot"
}

# Lambda EventBridge Trigger Module
module "eventbridge_trigger" {
  source = "./modules/eventbridge_trigger"
  lambda_function_arn  = module.lambda_snapshot.function_arn
  lambda_function_name = module.lambda_snapshot.function_name
  schedule_expression  = "cron(0 0 ? * 1 *)"  # Every Sunday at 00:00 UTC
}

# Lambda Cleanup Module
module "eventbridge_cleanup_trigger" {
  source               = "./modules/eventbridge_trigger"
  lambda_function_arn  = module.lambda_cleanup.function_arn
  lambda_function_name = module.lambda_cleanup.function_name
  schedule_expression  = "cron(0 0 ? * 1 *)"  # Every Sunday at 00:00 UTC
}


# CloudWatch Logs Module
module "cloudwatch_logs" {
  source = "./modules/cloudwatch_logs"
}

# SNS Alert Module
module "sns_alert" {
  source             = "./modules/sns_alert"
  notification_email = "villanuevakevin08@outlook.com"  # Replace with your real email
}

# Lambda Cleanup Module
module "lambda_cleanup" {
  source = "./modules/lambda_cleanup"
}

