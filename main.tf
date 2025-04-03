module "s3" {
  source = "./modules/s3"
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"
  raw_transform_role_arn    = module.iam.lambda_transform_role_arn
  glue_trigger_role_arn     = module.iam.lambda_glue_trigger_role_arn
  curated_bucket_name       = module.s3.curated_bucket_name
}

module "firehose" {
  source = "./modules/firehose"
  raw_bucket_arn       = module.s3.raw_bucket_arn
  curated_bucket_arn   = module.s3.curated_bucket_arn
  raw_role_arn         = module.iam.firehose_raw_role_arn
  curated_role_arn     = module.iam.firehose_curated_role_arn
  lambda_transform_arn = module.lambda.transform_lambda_arn
}

module "glue" {
  source = "./modules/glue"
  glue_role_arn = module.iam.glue_job_role_arn
}

module "events" {
  source = "./modules/events"
  lambda_glue_trigger_arn = module.lambda.glue_trigger_lambda_arn
  curated_bucket_name     = module.s3.curated_bucket_name
}

module "container" {
  source              = "./modules/container"
  raw_stream_name     = module.firehose.raw_stream_name
  curated_stream_name = module.firehose.curated_stream_name
}