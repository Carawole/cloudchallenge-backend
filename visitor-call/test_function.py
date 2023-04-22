import unittest
import json
import importlib

function = importlib.import_module("function")
handler = function.handler

class TestLamba(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)

if __name__ == '__main__':
    unittest.main()
      
