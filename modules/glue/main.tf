# modules/glue/main.tf

variable "glue_role_arn" {}

# Create an S3 bucket for Glue script
resource "aws_s3_bucket" "glue_script_bucket" {
  bucket = "glue-script-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Copy glue_script.py to the bucket
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.glue_script_bucket.id
  key    = "glue_script.py"
  source = "glue_script.py"  # local path to the script file
  etag   = filemd5("glue_script.py")
}

resource "aws_glue_job" "curated_to_final" {
  name     = "firehose-glue-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.glue_script_bucket.bucket}/glue_script.py"
    python_version  = "3"
  }

  glue_version       = "3.0"
  max_retries        = 0
  number_of_workers  = 2
  worker_type        = "Standard"
}

output "glue_job_name" {
  value = aws_glue_job.curated_to_final.name
}

output "glue_script_bucket" {
  value = aws_s3_bucket.glue_script_bucket.bucket
}