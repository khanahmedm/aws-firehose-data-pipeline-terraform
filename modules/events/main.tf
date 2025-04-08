# modules/events/main.tf

variable "lambda_glue_trigger_arn" {}
variable "curated_bucket_name" {}

resource "aws_cloudwatch_event_rule" "trigger_glue" {
  name          = "trigger-glue-job"
  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["${var.curated_bucket_name}"]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.trigger_glue.name
  target_id = "glueTrigger"
  arn       = var.lambda_glue_trigger_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = element(split(":", var.lambda_glue_trigger_arn), length(split(":", var.lambda_glue_trigger_arn)) - 1)
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_glue.arn
}
