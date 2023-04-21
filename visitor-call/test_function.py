import unittest

target = __import__(function.py)
handler = target.handler

class TestLamba(unittest.TestCase):
    def test_handler(self):
        self.assertEqual(handler(("status","test")["statusCode"],200))
