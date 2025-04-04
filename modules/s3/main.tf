# modules/s3/main.tf

resource "aws_s3_bucket" "raw" {
  bucket = "firehose-raw-data-amk"
}

resource "aws_s3_bucket" "curated" {
  bucket = "firehose-curated-data-amk"
}

resource "aws_s3_bucket" "final" {
  bucket = "firehose-final-data-amk"
}

output "raw_bucket_arn" {
  value = aws_s3_bucket.raw.arn
}

output "curated_bucket_arn" {
  value = aws_s3_bucket.curated.arn
}

output "final_bucket_name" {
  value = aws_s3_bucket.final.bucket
}

output "curated_bucket_name" {
  value = aws_s3_bucket.curated.bucket
}  
