import unittest
from service.service import hello_world_fn

class TestService(unittest.TestCase):

    def test_hello_world_fn(self):
        res = hello_world_fn()
        self.assertEqual(res, b'Hello, World!')

if __name__ == '__main__':
    unittest.main()