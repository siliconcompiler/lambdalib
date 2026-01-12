try:
    import cocotb

    from cocotb.clock import Clock
    from cocotb.triggers import Timer, RisingEdge, ReadOnly
    from lambdalib.reusable_tests.cocotb_common import run_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Sim, Project
from lambdalib.auxlib import Rsync


if _has_cocotb:
    @cocotb.test()
    async def test_la_rsync_basic(dut):
        """Test basic asynchronous assertion and synchronous de-assertion"""

        clk_period_ns = 10
        STAGES = int(dut.STAGES.value)

        nrst_in = dut.nrst_in
        nrst_out = dut.nrst_out

        # De-assert reset during start of test
        nrst_in.value = 1

        # Start clock
        Clock(dut.clk, clk_period_ns, unit="ns").start()

        ####################################
        # 1. Trigger Asynchronous Reset
        ####################################
        await RisingEdge(dut.clk)
        # Assert reset offset from clock edge
        await Timer(clk_period_ns/2, unit="ns")
        nrst_in.value = 0

        # Check for immediate (asynchronous) assertion
        await Timer(1, unit="step")
        assert nrst_out.value == 0, "Reset output did not assert immediately!"

        ####################################
        # 2. Trigger De-assertion
        ####################################
        await Timer(clk_period_ns*2, unit="ns")
        nrst_in.value = 1

        # Wait for the synchronizer pipeline to clear.
        cycle = 0
        while True:
            await ReadOnly()
            # Check if it de-asserts too early
            if cycle < STAGES:
                assert nrst_out.value == 0, f"Reset de-asserted too early at cycle {cycle}"
            else:
                assert nrst_out.value == 1, f"Reset failed to de-assert {cycle}"
                break

            await RisingEdge(dut.clk)
            cycle += 1

        await RisingEdge(dut.clk)
else:
    def test_la_rsync_basic():
        """Placeholder test when cocotb is not installed."""
        pass


def run_test(
    stages: int,
    simulator: str,
    output_wave: bool,
    project: Project = None,
):
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    if project is None:
        project = Sim(Rsync())
        project.add_fileset("rtl")

    test_inst_name = f"stages_{stages}_sim_{simulator}_output_wave{output_wave}"

    test_module_name = __name__
    test_name = f"{test_module_name}_{test_inst_name}"
    tests_failed = run_cocotb(
        project=project,
        test_module_name=test_module_name,
        simulator_name=simulator,
        timescale=("1ns", "1ps"),
        parameters={
            "STAGES": stages
        },
        output_dir_name=test_name,
        waves=output_wave
    )
    assert (tests_failed == 0), f"Error test {test_name} failed!"
