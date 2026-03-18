import itertools
import pytest


@pytest.mark.eda
@pytest.mark.parametrize("stages, simulator, output_wave", list(itertools.product(
    [2, 3, 4],
    ["icarus"],
    [False]
)))
def test_la_dsync(
    stages: int,
    simulator: str,
    output_wave: bool,
):
    from lambdalib.reusable_tests.auxlib.la_dsync.la_dsync_test import run_test
    run_test(
        stages=stages,
        simulator=simulator,
        output_wave=output_wave
    )
