import pytest
from lambdalib.ramlib.la_asyncfifo.testbench import tb_la_asyncfifo


@pytest.mark.eda
def test_la_asyncfifo():
    tb_la_asyncfifo.load_cocotb_test()
