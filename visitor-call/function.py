import boto3
import json

dynamo = boto3.resource('dynamodb').Table("VisitorCount")

def handler(event, context):
    response = dynamo.get_item(
        Key={
            'ClicksOnResume': 0
        }
    )
    item = response['Item']
    n = item['Num']
    dynamo.update_item(
        Key={
            'ClicksOnResume': 0,
        },
        UpdateExpression='SET Num = :val1',
        ExpressionAttributeValues={
            ':val1': n + 1, 
        }
    )
    response = dynamo.get_item(
        Key={
            'ClicksOnResume': 0
        }
    )
    item = response['Item']
    x = json.dumps(int(item['Num']))
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': 'https://www.chrisarawole.com',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'isBase64Encoded': 'false',
        'body': x
    }