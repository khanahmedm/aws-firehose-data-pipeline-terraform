import base64
import json
from datetime import datetime

def lambda_handler(event, context):
    output = []
    for record in event['records']:
        payload = json.loads(base64.b64decode(record['data']).decode('utf-8'))
        
        # Transformation example: add total_price
        payload['timestamp'] = datetime.utcnow().isoformat()
        transformed_record = json.dumps(payload) + '\n'
        
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': base64.b64encode(transformed_record.encode('utf-8')).decode('utf-8')
        }
        output.append(output_record)
        
    return {'records': output}
