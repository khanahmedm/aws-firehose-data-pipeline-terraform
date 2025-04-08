# modules/firehose/main.tf

variable "raw_bucket_arn" {}
variable "curated_bucket_arn" {}
variable "raw_role_arn" {}
variable "curated_role_arn" {}
variable "lambda_transform_arn" {}

resource "aws_kinesis_firehose_delivery_stream" "raw" {
  name        = "firehose-raw-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.raw_role_arn
    bucket_arn = var.raw_bucket_arn
  }
}

resource "aws_kinesis_firehose_delivery_stream" "curated" {
  name        = "firehose-curated-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.curated_role_arn
    bucket_arn = var.curated_bucket_arn

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = var.lambda_transform_arn
        }
      }
    }
  }
}

output "raw_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.raw.name
}

output "curated_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.curated.name
}
