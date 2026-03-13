try:
    import cocotb

    from cocotb.triggers import Timer, ValueChange
    from lambdalib.reusable_tests.cocotb_common import load_cocotb_test
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Design
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


class TbDesign(Design):

    def __init__(
        self,
        stages: int,
        rsync: Design = None,
        rsync_fileset="rtl"
    ):
        super().__init__()

        name = f"tb_{rsync.name}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_rsync")
                self.add_file("la_rsync_test.py", filetype="python")
                self.add_depfileset(rsync, rsync_fileset)
                self.set_param("STAGES", str(stages))


def run_test(
    stages: int,
    simulator: str,
    output_wave: bool,
    rsync: Design = None,
    rsync_fileset: str = "rtl"
):
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    if rsync is None:
        rsync = Rsync()

    load_cocotb_test(
        design=TbDesign(
            stages=stages,
            rsync=rsync,
            rsync_fileset=rsync_fileset
        ),
        simulator=simulator,
        trace=output_wave,
        seed=None
    )
