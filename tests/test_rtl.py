import pytest


@pytest.mark.eda
def test_la_asyncfifo():
    import lambdalib.ramlib.tests.tb_la_asyncfifo as ramlib_tests
    ramlib_tests.test_la_asyncfifo()
