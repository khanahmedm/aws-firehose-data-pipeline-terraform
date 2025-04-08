import boto3

def lambda_handler(event, context):
    #glue = boto3.client('glue')
    #response = glue.start_job_run(JobName='firehose-CuratedToFinalETLJob')
    #return response
    
    s3_bucket = event['detail']['bucket']['name']
    s3_key = event['detail']['object']['key']
    
    glue = boto3.client('glue')
    response = glue.start_job_run(
        JobName='firehose-CuratedToFinalETLJob',
        Arguments={
            '--s3_input_path': f's3://{s3_bucket}/{s3_key}'
        }
    )
    return response
