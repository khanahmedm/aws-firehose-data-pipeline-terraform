# modules/lambda/main.tf

variable "raw_transform_role_arn" {}
variable "glue_trigger_role_arn" {}
variable "curated_bucket_name" {}

resource "aws_lambda_function" "transform" {
  function_name = "firehose-data-transformation"
  role          = var.raw_transform_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_transform.zip"
  source_code_hash = filebase64sha256("lambda_transform.zip")
}

resource "aws_lambda_function" "glue_trigger" {
  function_name = "start-firehose-glue-job"
  role          = var.glue_trigger_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_glue_trigger.zip"
  source_code_hash = filebase64sha256("lambda_glue_trigger.zip")
}

output "transform_lambda_arn" {
  value = aws_lambda_function.transform.arn
}

output "glue_trigger_lambda_arn" {
  value = aws_lambda_function.glue_trigger.arn
}
