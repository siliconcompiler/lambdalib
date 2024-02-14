import pytest
import os


@pytest.fixture(autouse=True)
def test_wrapper(tmp_path):
    topdir = os.getcwd()
    os.chdir(tmp_path)
    # Run the test.
    yield
    os.chdir(topdir)
