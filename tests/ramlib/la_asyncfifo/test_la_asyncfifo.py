import itertools
import pytest


@pytest.mark.eda
@pytest.mark.timeout(240)
@pytest.mark.parametrize("depth, simulator, output_wave", list(itertools.product(
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    ["icarus", "verilator"],
    [False]
)))
def test_la_asyncfifo(
    depth: int,
    simulator: str,
    output_wave: bool,
):
    pytest.importorskip("cocotb")
    from lambdalib.reusable_tests.ramlib.la_asyncfifo.test_la_asyncfifo import run_test
    run_test(
        depth=depth,
        simulator=simulator,
        output_wave=output_wave
    )
