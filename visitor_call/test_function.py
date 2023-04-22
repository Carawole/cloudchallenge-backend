import unittest
import json

from visitor_call.function import handler

class TestLamba(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)

if __name__ == '__main__':
    unittest.main()
      
