import itertools
import pytest


@pytest.mark.eda
@pytest.mark.parametrize("dw, aw, simulator, output_wave", list(itertools.product(
    [8, 16, 32],
    [4, 8],
    ["icarus"],
    [False]
)))
def test_la_tdpram(
    dw: int,
    aw: int,
    simulator: str,
    output_wave: bool,
):
    from lambdalib.reusable_tests.ramlib.la_tdpram.la_tdpram_test import run_test
    run_test(
        dw=dw,
        aw=aw,
        simulator=simulator,
        output_wave=output_wave
    )
