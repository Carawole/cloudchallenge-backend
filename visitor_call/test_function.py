import unittest
import json
from visitor_call.function import handler
import boto3

class test_lambda(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)