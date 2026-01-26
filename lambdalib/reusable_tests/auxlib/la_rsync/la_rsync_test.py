try:
    import cocotb

    from cocotb.triggers import Timer, ValueChange
    from lambdalib.reusable_tests.cocotb_common import run_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Sim, Project
from lambdalib.auxlib import Rsync


if _has_cocotb:

    async def drive_clock(clk, period_ns, n=1):
        half_period = period_ns / 2
        for _ in range(n):
            clk.value = 0
            await Timer(half_period, unit="ns")
            clk.value = 1
            await Timer(half_period, unit="ns")

    @cocotb.test()
    async def test_la_rsync_basic(dut):
        """Test basic asynchronous assertion and synchronous de-assertion"""

        STAGES = int(dut.STAGES.value)
        clk_period_ns = 10

        nrst_in = dut.nrst_in
        nrst_out = dut.nrst_out
        clk = dut.clk

        for _ in range(3):
            # Drive clock signal
            clk.value = 0

            # De-assert reset during start of test
            nrst_in.value = 1

            await Timer(clk_period_ns*2, unit="ns")

            ####################################
            # 1. Trigger Asynchronous Reset
            ####################################

            # Assert reset
            nrst_in.value = 0

            # Check for asynchronous assertion
            await ValueChange(nrst_out)
            assert nrst_out.value == 0, "Reset output did not assert immediately!"

            ####################################
            # 2. Trigger De-assertion
            ####################################
            await Timer(clk_period_ns*2, unit="ns")
            nrst_in.value = 1
            await Timer(clk_period_ns*2, unit="ns")

            # Wait for the synchronizer pipeline to clear.
            for cycle in range(STAGES+1):
                # Check if it de-asserts too early
                if cycle < STAGES:
                    assert nrst_out.value == 0, f"Reset de-asserted too early at cycle {cycle}"
                else:
                    assert nrst_out.value == 1, f"Reset failed to de-assert {cycle}"
                    break

                await drive_clock(clk, clk_period_ns)

else:
    def test_la_rsync_basic():
        """Placeholder test when cocotb is not installed."""
        pass


def run_test(
    stages: int,
    simulator: str,
    output_wave: bool,
    project: Project = None
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
