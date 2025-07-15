import pytest
import lambdalib
from lambdalib.ramlib.la_asyncfifo.testbench import tb_la_asyncfifo

@pytest.mark.eda
def test_la_asyncfifo():
    tb_la_asyncfifo.test_la_asyncfifo()
