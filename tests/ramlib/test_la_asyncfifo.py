import itertools
import pytest


@pytest.mark.eda
@pytest.mark.timeout(240)
@pytest.mark.parametrize("depth, simulator, output_wave", list(itertools.product(
    [2, 4, 8, 16],
    ["icarus", "verilator"],
    [False]
)))
def test_la_asyncfifo(
    depth: int,
    simulator: str,
    output_wave: bool,
):
    pytest.importorskip("cocotb")
    from lambdalib.reusable_tests.ramlib.la_asyncfifo.la_asyncfifo_test import run_test
    run_test(
        depth=depth,
        simulator=simulator,
        output_wave=output_wave
    )
