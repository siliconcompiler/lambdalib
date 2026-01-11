import itertools
import pytest


@pytest.mark.eda
@pytest.mark.parametrize("stages, simulator, output_wave", list(itertools.product(
    [2, 3, 4],
    ["icarus", "verilator"],
    [False]
)))
def test_la_rsync(
    stages: int,
    simulator: str,
    output_wave: bool,
):
    from lambdalib.reusable_tests.auxlib.la_rsync.la_rsync_test import run_test
    run_test(
        stages=stages,
        simulator=simulator,
        output_wave=output_wave
    )
