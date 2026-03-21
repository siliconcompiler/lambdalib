try:
    import cocotb
    import os

    from cocotb.triggers import Timer
    from cocotb.clock import Clock
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Design, Sim
from lambdalib.ramlib import Spram


if _has_cocotb:

    async def wait_cycles(clk, n):
        """Wait for n clock cycles by monitoring clock edges"""
        for _ in range(n):
            await cocotb.triggers.RisingEdge(clk)

    async def write_operations(dut, DW, clk_period_ns):
        """Write operations"""
        clk = dut.clk
        ce = dut.ce
        we = dut.we
        wmask = dut.wmask
        addr = dut.addr
        din = dut.din

        # Write pattern 0xAAAA to address 0
        addr.value = 0
        din.value = 0xAAAA & ((1 << DW) - 1)
        wmask.value = (1 << DW) - 1
        ce.value = 1
        we.value = 1
        await wait_cycles(clk, 1)

        # Write pattern 0x5555 to address 1
        addr.value = 1
        din.value = 0x5555 & ((1 << DW) - 1)
        await wait_cycles(clk, 1)

        # Write pattern 0xFFFF to address 2
        addr.value = 2
        din.value = (1 << DW) - 1
        await wait_cycles(clk, 1)

    async def read_operations(dut, DW, clk_period_ns):
        """Read operations"""
        clk = dut.clk
        we = dut.we
        addr = dut.addr
        dout = dut.dout

        # Switch to read mode
        we.value = 0

        # Read from address 0
        addr.value = 0
        await wait_cycles(clk, 2)
        assert dout.value == (0xAAAA & ((1 << DW) - 1)), \
            f"Read from addr 0 failed: {hex(dout.value)}"

        # Read from address 1
        addr.value = 1
        await wait_cycles(clk, 2)
        assert dout.value == (0x5555 & ((1 << DW) - 1)), \
            f"Read from addr 1 failed: {hex(dout.value)}"

        # Read from address 2
        addr.value = 2
        await wait_cycles(clk, 2)
        assert dout.value == ((1 << DW) - 1), \
            f"Read from addr 2 failed: {hex(dout.value)}"

    async def all_addresses(dut, DW, AW, clk_period_ns):
        """Write and read from all addresses"""
        clk = dut.clk
        ce = dut.ce
        we = dut.we
        wmask = dut.wmask
        addr = dut.addr
        din = dut.din
        dout = dut.dout
        depth = 2 ** AW

        # Write unique pattern to every address
        we.value = 1
        wmask.value = (1 << DW) - 1
        ce.value = 1

        for test_addr in range(depth):
            addr.value = test_addr
            test_pattern = (test_addr * 0x1111) & ((1 << DW) - 1)
            din.value = test_pattern
            await wait_cycles(clk, 1)

        # Read back and verify every address
        we.value = 0
        for test_addr in range(depth):
            addr.value = test_addr
            await wait_cycles(clk, 2)
            expected_pattern = (test_addr * 0x1111) & ((1 << DW) - 1)
            assert dout.value == expected_pattern, \
                f"Address {test_addr} mismatch: got {hex(dout.value)}, " \
                f"expected {hex(expected_pattern)}"

    @cocotb.test()
    async def test_la_spram_basic(dut):
        """Test basic read/write operations of single-port RAM"""
        DW = int(dut.DW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        clk = dut.clk
        ce = dut.ce
        we = dut.we
        wmask = dut.wmask
        addr = dut.addr
        din = dut.din
        ctrl = dut.ctrl

        # Initialize
        ce.value = 0
        we.value = 0
        wmask.value = 0
        addr.value = 0
        din.value = 0
        ctrl.value = CTRL_VALUE

        # Start clock using cocotb Clock
        cocotb.start_soon(Clock(clk, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Run tests
        await write_operations(dut, DW, clk_period_ns)
        await read_operations(dut, DW, clk_period_ns)

    @cocotb.test()
    async def test_la_spram_all_addresses(dut):
        """Test all address coverage for single-port RAM"""
        DW = int(dut.DW.value)
        AW = int(dut.AW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        clk = dut.clk
        ce = dut.ce
        we = dut.we
        wmask = dut.wmask
        addr = dut.addr
        din = dut.din
        ctrl = dut.ctrl

        # Initialize
        ce.value = 0
        we.value = 0
        wmask.value = 0
        addr.value = 0
        din.value = 0
        ctrl.value = CTRL_VALUE

        # Start clock using cocotb Clock
        cocotb.start_soon(Clock(clk, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Run comprehensive test
        await all_addresses(dut, DW, AW, clk_period_ns)


else:
    def test_la_spram_basic():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):

    def __init__(
        self,
        dw: int,
        aw: int,
        simulator: str = "icarus",
        ctrl: int = 0,
        name: str = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_test_la_spram_dw{dw}_aw{aw}_ctrl{ctrl}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_spram_impl")
                self.add_depfileset(Spram(), "rtl")
                self.set_param("DW", str(dw))
                self.set_param("AW", str(aw))

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_spram_test.py", filetype="python")


def run_test(
    dw: int,
    aw: int,
    simulator: str,
    output_wave: bool,
    ctrl: int = 0
):
    """Run tests for a single configuration."""
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    project = Sim(TbDesign(dw, aw, simulator, ctrl))
    project.add_fileset("testbench.cocotb")
    project.option.set_env("CTRL_VALUE", str(ctrl))
    use_cocotb(project=project, trace=output_wave)
    project.set_flow(f"dvflow-{simulator}-cocotb")

    project.run()
    project.summary()
