import os

import random
from pathlib import Path

from cocotb.triggers import Timer
from cocotb.runner import get_runner, get_results

import siliconcompiler
from siliconcompiler.tools.slang import elaborate


def run_cocotb(
        chip: siliconcompiler.Chip,
        test_module_name,
        output_dir_name=None,
        simulator_name="icarus",
        timescale=None,
        parameters={}):

    # Use surelog to pickle Verilog sources
    flow = "cocotb_flow"
    chip.node(flow, "import", elaborate)
    chip.set("option", "flow", flow)
    assert chip.run()

    pickled_verilog = chip.find_result("v", "import")
    assert pickled_verilog, "Could not locate pickled verilog"

    if output_dir_name is None:
        output_dir_name = test_module_name

    top_level_dir = os.getcwd()
    build_dir = Path(chip.getbuilddir()) / output_dir_name
    test_dir = None

    results_xml = None
    # Need to check if we are running inside of pytest. See link below.
    # https://github.com/cocotb/cocotb/blob/d883ce914063c3601455d10a40f459fffa22d8f2/cocotb/runner.py#L313
    if not os.getenv("PYTEST_CURRENT_TEST", None):
        results_xml = build_dir / "results.xml"
        test_dir = top_level_dir

    # Build HDL in chosen simulator
    runner = get_runner(simulator_name)
    runner.build(
        sources=[pickled_verilog],
        hdl_toplevel=chip.design,
        waves=True,
        timescale=timescale,
        build_dir=build_dir,
        parameters=parameters
    )
    # Run test
    _, tests_failed = get_results(runner.test(
        hdl_toplevel=chip.top(),
        test_module=test_module_name,
        test_dir=test_dir,
        results_xml=results_xml,
        build_dir=build_dir,
        timescale=timescale,
        waves=True
    ))

    return tests_failed


async def drive_reset(reset, reset_time_in_ns=100, active_level=False):
    reset.value = 1 if active_level else 0
    await Timer(reset_time_in_ns, units="ns")
    reset.value = 0 if active_level else 1


def random_bool_generator():
    while True:
        yield (random.randint(0, 1) == 1)
