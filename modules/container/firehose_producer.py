# firehose_producer.py
import boto3
import json
import time
import random
from datetime import datetime

# Create a Firehose client
firehose = boto3.client('firehose', region_name='us-east-1')  # change region

RAW_STREAM = 'firehose-raw-delivery-stream'
TRANSFORMED_STREAM = 'PUT-S3-QWLcq'

def generate_data():
    return {
        "event_time": datetime.utcnow().isoformat(),
        "user_id": random.randint(1000, 9999),
        "event_type": random.choice(["click", "view", "purchase"]),
        "product_id": random.randint(100, 200)
    }

def send_to_firehose():
    while True:
        record = json.dumps(generate_data()) + '\n'
        
        # Send to raw stream
        raw_response = firehose.put_record(
            DeliveryStreamName=RAW_STREAM,
            Record={"Data": record}
        )

        # Send to transformed stream
        transformed_response = firehose.put_record(
            DeliveryStreamName=TRANSFORMED_STREAM,
            Record={"Data": record}
        )

        #print("Sent:", record.strip(), "Status:", response['ResponseMetadata']['HTTPStatusCode'])

        print("Raw:", raw_response['ResponseMetadata']['HTTPStatusCode'],
              "Transformed:", transformed_response['ResponseMetadata']['HTTPStatusCode'])

        time.sleep(1)

if __name__ == "__main__":
    send_to_firehose()
