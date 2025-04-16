import pytest

import lambdalib.ramlib.tests.tb_la_asyncfifo as ramlib_tests


@pytest.mark.eda
def test_la_asyncfifo():
    ramlib_tests.test_la_asyncfifo()
