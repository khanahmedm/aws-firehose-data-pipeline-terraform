# modules/iam/main.tf

# Trust policies

data "aws_iam_policy_document" "firehose_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Firehose IAM roles
resource "aws_iam_role" "firehose_raw_role" {
  name               = "KinesisFirehoseServiceRole-firehose-raw"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume.json
}

resource "aws_iam_role" "firehose_curated_role" {
  name               = "KinesisFirehoseServiceRole-firehose-curated"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume.json
}

# Lambda IAM roles
resource "aws_iam_role" "lambda_transform_role" {
  name               = "firehose-data-transformation-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role" "lambda_glue_trigger_role" {
  name               = "start-firehose-glue-job-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Glue IAM role
resource "aws_iam_role" "glue_job_role" {
  #name               = "AWSGlueServiceRole-financial-data"
  name               = "firehose-glue-job-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Outputs
output "firehose_raw_role_arn" {
  value = aws_iam_role.firehose_raw_role.arn
}

output "firehose_curated_role_arn" {
  value = aws_iam_role.firehose_curated_role.arn
}

output "lambda_transform_role_arn" {
  value = aws_iam_role.lambda_transform_role.arn
}

output "lambda_glue_trigger_role_arn" {
  value = aws_iam_role.lambda_glue_trigger_role.arn
}

output "glue_job_role_arn" {
  value = aws_iam_role.glue_job_role.arn
}
