import boto3
import uuid
from datetime import datetime
import os
import json

# Initialize AWS clients
dynamodb = boto3.client('dynamodb')
secrets_manager = boto3.client('secretsmanager')

def get_auth_response(secret_id):
    """
    Retrieves and parses the authentication response from Secrets Manager.
    """
    try:
        # Get the secret value from Secrets Manager
        response = secrets_manager.get_secret_value(SecretId=secret_id)
        
        # Parse the secret string into JSON format
        auth_response = json.loads(response['SecretString'])
        print("Successfully retrieved authentication response from Secrets Manager.")
        
        return auth_response

    except Exception as e:
        print(f"Error retrieving authentication response: {str(e)}")
        return None

def lambda_handler(event, context):
    # Retrieve necessary information from the event
    user_id = event.get('user_id')
    transaction_id = event.get('transaction_id')
    payment_amount = event.get('payment_amount', 'unknown')
    payment_status = event.get('payment_status', 'Not processed')

    # Validate required fields
    if not user_id or not transaction_id:
        error_message = "Missing required parameters: 'user_id' and/or 'transaction_id'."
        print(error_message)
        return {
            'statusCode': 400,
            'body': json.dumps({'error': error_message})
        }

    # Get the Secrets Manager secret ID from environment variables
    secret_id = os.getenv('AUTH_RESPONSE')
    if not secret_id:
        error_message = "Authentication response secret ID not set in environment variables."
        print(error_message)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message})
        }

    # Fetch the authentication response
    auth_response = get_auth_response(secret_id)
    if not auth_response:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to retrieve authentication response.'})
        }

    # Extract necessary fields from the authentication response
    auth_token = auth_response.get('auth_token')
    expiration_time = auth_response.get('expiration_time')
    if not auth_token:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Authentication token missing in response.'})
        }

    # Process the payment (Placeholder for actual payment logic using auth_token)
    try:
        # Simulate payment processing logic if necessary
        # Example: payment_status = process_payment(auth_token, payment_amount)
        print(f"Using auth_token {auth_token} for transaction_id: {transaction_id}")
        
        # Create audit log entry in DynamoDB
        dynamodb.put_item(
            TableName=os.environ.get('DYNAMODB_TABLE_NAME', 'default_audit_table'),
            Item={
                'audit_id': {'S': str(uuid.uuid4())},
                'user_identity': {'S': user_id},
                'access_timestamp': {'S': datetime.utcnow().isoformat()},
                'transaction_id': {'S': transaction_id},
                'payment_amount': {'S': str(payment_amount)},
                'payment_status': {'S': payment_status},
                'auth_token_used': {'S': auth_token},
                'token_expiration': {'S': expiration_time}
            }
        )
        print(f"Audit log entry created for transaction_id: {transaction_id}")

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Payment processed and audit logged.'})
        }

    except Exception as e:
        # Log detailed error information
        error_message = f"Error logging payment audit entry for transaction_id {transaction_id}: {str(e)}"
        print(error_message)
        
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message})
        }
