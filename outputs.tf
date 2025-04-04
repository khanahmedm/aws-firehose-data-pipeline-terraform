output "firehose_raw_stream" {
  value = module.firehose.raw_stream_name
}

output "firehose_curated_stream" {
  value = module.firehose.curated_stream_name
}

output "final_output_bucket" {
  value = module.s3.final_bucket_name
}