import boto3
import json
import uuid
import datetime

dynamodb = boto3.client('dynamodb')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Scan the PaymentAuditTrail DynamoDB table
    response = dynamodb.scan(
        TableName='PaymentAuditTrail'
    )
    
    # Create a unique backup file name with timestamp
    backup_file_name = f"backup-{str(datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S'))}.json"
    
    # Prepare the backup data
    backup_data = json.dumps(response['Items'], default=str)

    # Store the backup in S3
    s3.put_object(
        Bucket='payment-refund-backups',
        Key=backup_file_name,
        Body=backup_data
    )
    
    return {
        'statusCode': 200,
        'body': f'Backup created successfully: {backup_file_name}'
    }
