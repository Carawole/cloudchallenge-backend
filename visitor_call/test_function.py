import unittest
import json
from visitor_call.function import handler
#import boto3
#from contextlib import contextmanager


class test_lambda(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)

#if __name__ == '__main__':
#    unittest.main()
"""
class test_lambda(unittest.TestCase):
    @mock_dynamodb
    def test_get_from_dynamo(dynamo):
        from visitor_call import function
        handler = function.handler
        dynamo = boto3.resource('dynamodb', region_name='us-east-1')
        table_name = 'VisitorCount'
        table = dynamo.create_table(TableName=table_name,
            KeySchema=[{'AttributeName': 'ClicksOnResume','KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'ClicksOnResume','AttributeType': 'N'}],
            ProvisionedThroughput={'ReadCapacityUnits': 1,'WriteCapacityUnits': 1})
        table.put_item(
            Item={
                "ClicksOnResume" : 0,
                "Num" : 1
            }
        )
        #handler('','')
        #status_Code = handler["statusCode"]
        #assert status_Code == 200
        self.assertEqual(handler("status","test")["statusCode"],200)

"""
