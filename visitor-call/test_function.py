import unittest
import json

from function import handler

class TestLamba(unittest.TestCase):
    def test_handler(self):
        print("Running unit test...")
        self.assertEqual(handler("status","test")["statusCode"],200)
