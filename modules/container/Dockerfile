# container/Dockerfile
FROM public.ecr.aws/lambda/python:3.9

# Copy the producer script
COPY firehose_producer.py ./

# Install dependencies
RUN pip install boto3

# Run the script (boto3 runs outside Lambda handler)
CMD ["firehose_producer.py"]