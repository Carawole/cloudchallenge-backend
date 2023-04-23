import unittest
import json

from function import handler

class test_lambda(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)

if __name__ == '__main__':
    unittest.main()


