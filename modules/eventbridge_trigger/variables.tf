variable "lambda_function_arn" {
  description = "ARN of the Lambda function to trigger"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to grant permissions to"
  type        = string
}
variable "schedule_expression" {
  description = "EventBridge schedule expression"
  type        = string
}
