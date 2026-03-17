try:
    import cocotb

    from cocotb.triggers import Timer
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Design, Sim
from lambdalib.auxlib import Drsync


if _has_cocotb:

    async def drive_clock(clk, period_ns, n=1):
        half_period = period_ns / 2
        for _ in range(n):
            clk.value = 0
            await Timer(half_period, unit="ns")
            clk.value = 1
            await Timer(half_period, unit="ns")

    @cocotb.test()
    async def test_la_drsync_basic(dut):
        """Test data synchronization with async reset"""

        STAGES = int(dut.STAGES.value)
        clk_period_ns = 10

        clk = dut.clk
        nreset = dut.nreset
        input_data = dut['in']
        output_data = dut.out

        # Initialize
        clk.value = 0
        nreset.value = 1
        input_data.value = 0

        await Timer(clk_period_ns * 2, unit="ns")

        ####################################
        # 1. Test Synchronous Reset
        ####################################

        # Assert reset
        nreset.value = 0
        await Timer(clk_period_ns / 2, unit="ns")

        # Check output is reset to 0
        assert output_data.value == 0, "Output should be 0 after reset"

        nreset.value = 1
        await Timer(clk_period_ns, unit="ns")

        ####################################
        # 2. Test Data Propagation
        ####################################

        # Set input to 1 and clock STAGES times to propagate through synchronizer
        input_data.value = 1
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)

        # Now output should be 1
        assert output_data.value == 1, \
            f"Output should be 1 after {STAGES} clock cycles with input=1"

        # Set input to 0 and clock STAGES times
        input_data.value = 0
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)

        # Now output should be 0
        assert output_data.value == 0, \
            f"Output should be 0 after {STAGES} clock cycles with input=0"

        # Test multiple transitions by toggling input and waiting for propagation
        input_data.value = 1
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)
        assert output_data.value == 1, "Second rising edge should propagate correctly"

        input_data.value = 0
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)
        assert output_data.value == 0, "Second falling edge should propagate correctly"

        ####################################
        # 3. Test Reset During Operation
        ####################################

        # Drive some data
        input_data.value = 1
        await drive_clock(clk, clk_period_ns, n=2)

        # Assert reset while data is propagating
        nreset.value = 0
        await Timer(clk_period_ns / 2, unit="ns")

        # Output should immediately go to 0
        assert output_data.value == 0, "Output should immediately reset to 0"

        nreset.value = 1
        await Timer(clk_period_ns, unit="ns")


else:
    def test_la_drsync_basic():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):

    def __init__(
        self,
        stages: int,
        simulator: str = "icarus",
        name: str = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_test_la_drsync_stages_{stages}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_drsync")
                self.add_depfileset(Drsync(), "rtl")
                self.set_param("STAGES", str(stages))

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_drsync_test.py", filetype="python")


def run_test(
    stages: int,
    simulator: str,
    output_wave: bool
):
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    project = Sim(TbDesign(stages, simulator))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=output_wave)
    project.set_flow(f"dvflow-{simulator}-cocotb")

    project.run()
    project.summary()
