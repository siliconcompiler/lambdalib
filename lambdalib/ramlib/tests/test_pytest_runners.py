import pytest

import lambdalib.ramlib.make as runners


@pytest.mark.eda
def test_la_asyncfifo():
    runners.test_la_asyncfifo()
