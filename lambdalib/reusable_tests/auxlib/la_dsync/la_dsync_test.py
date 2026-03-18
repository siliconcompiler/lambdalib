try:
    import cocotb

    from cocotb.triggers import Timer
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from typing import Optional
from siliconcompiler import Design, Sim
from lambdalib.auxlib import Dsync


if _has_cocotb:

    async def drive_clock(clk, period_ns, n=1):
        half_period = period_ns / 2
        for _ in range(n):
            clk.value = 0
            await Timer(half_period, unit="ns")
            clk.value = 1
            await Timer(half_period, unit="ns")

    @cocotb.test()
    async def test_la_dsync_basic(dut):
        """Test basic data synchronization across clock domains"""

        STAGES = int(dut.STAGES.value)
        clk_period_ns = 10

        clk = dut.clk
        input_data = dut['in']
        output_data = dut.out

        # Initialize
        clk.value = 0
        input_data.value = 0

        await Timer(clk_period_ns * 2, unit="ns")

        ####################################
        # 1. Test Data Propagation - Rising Edge
        ####################################

        # Set input to 1
        input_data.value = 1

        # Clock through STAGES-1 cycles and verify no early propagation
        for _ in range(STAGES - 1):
            await drive_clock(clk, clk_period_ns)
        # Output should not yet be 1 (hasn't propagated yet)
        assert output_data.value != 1, f"Output changed too early before {STAGES} cycles"

        # Clock the final cycle
        await drive_clock(clk, clk_period_ns)

        # After STAGES cycles, output should be 1
        assert output_data.value == 1, f"Output should be 1 after {STAGES} cycles with input=1"

        ####################################
        # 2. Test Data Propagation - Falling Edge
        ####################################

        # Set input to 0
        input_data.value = 0

        # Clock through STAGES-1 cycles and verify no early propagation
        for _ in range(STAGES - 1):
            await drive_clock(clk, clk_period_ns)
        # Output should not yet be 0 (hasn't propagated yet)
        assert output_data.value != 0, f"Output changed too early before {STAGES} cycles"

        # Clock the final cycle
        await drive_clock(clk, clk_period_ns)

        # After STAGES cycles, output should be 0
        assert output_data.value == 0, f"Output should be 0 after {STAGES} cycles with input=0"

        ####################################
        # 3. Test Multiple Transitions
        ####################################

        # Test another rising edge
        input_data.value = 1
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)
        assert output_data.value == 1, "Second rising edge should propagate correctly"

        # Test another falling edge
        input_data.value = 0
        for _ in range(STAGES):
            await drive_clock(clk, clk_period_ns)
        assert output_data.value == 0, "Second falling edge should propagate correctly"

        ####################################
        # 4. Test Stability
        ####################################

        # Keep input stable and verify output remains stable
        for _ in range(10):
            await drive_clock(clk, clk_period_ns)
        assert output_data.value == 0, "Output should remain stable at 0"


else:
    def test_la_dsync_basic():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):

    def __init__(
        self,
        stages: int,
        simulator: str = "icarus",
        name: Optional[str] = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_test_la_dsync_stages_{stages}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_dsync")
                self.add_depfileset(Dsync(), "rtl")
                self.set_param("STAGES", str(stages))

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_dsync_test.py", filetype="python")


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
