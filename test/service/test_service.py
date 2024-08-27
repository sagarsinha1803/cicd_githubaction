import pytest
from service.service import hello_world_fn
import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))


def test_hello_world_fn():
    res = hello_world_fn()
    assert res == 'Hello World!'

if __name__ == '__main__':
    pytest.main()