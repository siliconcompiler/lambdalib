"""Cocotb tests for the la_dpram (dual-port RAM) module.

Contains two test strategies:
- **test_la_dpram_basic**: Writes known patterns via the write port, then reads
  and verifies them via the read port.
- **test_la_dpram_all_addresses**: Exhaustive write-then-read of every address
  in the memory using a deterministic address-derived pattern.

Also provides TbDesign and run_test() for SiliconCompiler-based simulation flow.
"""

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
from lambdalib.ramlib import Dpram


if _has_cocotb:

    async def wait_cycles(clk, n):
        """Wait for n clock cycles by monitoring clock edges"""
        for _ in range(n):
            await cocotb.triggers.RisingEdge(clk)

    async def write_operations(dut, DW):
        """Write port operations"""
        wr_clk = dut.wr_clk
        wr_ce = dut.wr_ce
        wr_we = dut.wr_we
        wr_wmask = dut.wr_wmask
        wr_addr = dut.wr_addr
        wr_din = dut.wr_din

        # Write 0xAAAA to address 0 on write port
        wr_addr.value = 0
        wr_din.value = 0xAAAA & ((1 << DW) - 1)
        wr_wmask.value = (1 << DW) - 1
        wr_ce.value = 1
        wr_we.value = 1
        await wait_cycles(wr_clk, 1)

        # Write 0x5555 to address 1
        wr_addr.value = 1
        wr_din.value = 0x5555 & ((1 << DW) - 1)
        await wait_cycles(wr_clk, 1)

        # Write 0xFFFF to address 2
        wr_addr.value = 2
        wr_din.value = (1 << DW) - 1
        await wait_cycles(wr_clk, 1)

    async def read_operations(dut, DW):
        """Read port operations"""
        wr_we = dut.wr_we
        rd_clk = dut.rd_clk
        rd_ce = dut.rd_ce
        rd_addr = dut.rd_addr
        rd_dout = dut.rd_dout

        # Switch to read-only mode on write port
        wr_we.value = 0

        # Enable read port and prime with first address
        rd_ce.value = 1
        rd_addr.value = 0
        await wait_cycles(rd_clk, 3)  # Extra cycle to ensure rd_dout is valid
        assert rd_dout.value == (0xAAAA & ((1 << DW) - 1)), \
            f"Read from addr 0 failed: {hex(rd_dout.value)}"

        # Read from address 1
        rd_addr.value = 1
        await wait_cycles(rd_clk, 2)
        assert rd_dout.value == (0x5555 & ((1 << DW) - 1)), \
            f"Read from addr 1 failed: {hex(rd_dout.value)}"

        # Read from address 2
        rd_addr.value = 2
        await wait_cycles(rd_clk, 2)
        assert rd_dout.value == ((1 << DW) - 1), f"Read from addr 2 failed: {hex(rd_dout.value)}"

    async def all_addresses(dut, DW, AW):
        """Write and read from all addresses"""
        wr_clk = dut.wr_clk
        wr_ce = dut.wr_ce
        wr_we = dut.wr_we
        wr_wmask = dut.wr_wmask
        wr_addr = dut.wr_addr
        wr_din = dut.wr_din
        rd_clk = dut.rd_clk
        rd_ce = dut.rd_ce
        rd_addr = dut.rd_addr
        rd_dout = dut.rd_dout
        depth = 2 ** AW
        data_mask = (1 << DW) - 1

        # Initialize write port
        wr_we.value = 1
        wr_wmask.value = data_mask
        wr_ce.value = 1

        # Clear memory first - write 0 to all addresses to ensure clean state
        for clear_addr in range(depth):
            wr_addr.value = clear_addr
            wr_din.value = 0
            await wait_cycles(wr_clk, 1)

        # Wait for memory clear to settle
        await wait_cycles(wr_clk, 2)

        # Write unique pattern to every address
        for test_addr in range(depth):
            wr_addr.value = test_addr
            test_pattern = (test_addr * 0x1111) & data_mask
            wr_din.value = test_pattern
            await wait_cycles(wr_clk, 1)

        # Allow writes to settle
        await wait_cycles(wr_clk, 2)

        # Read back and verify every address
        wr_we.value = 0
        rd_ce.value = 1
        rd_addr.value = 0
        await wait_cycles(rd_clk, 3)  # Prime the first read with extra cycle

        for test_addr in range(depth):
            rd_addr.value = test_addr
            await wait_cycles(rd_clk, 2)
            expected_pattern = (test_addr * 0x1111) & data_mask
            assert rd_dout.value == expected_pattern, \
                f"Address {test_addr} mismatch: got {hex(rd_dout.value)}, " \
                f"expected {hex(expected_pattern)}"

    @cocotb.test()
    async def test_la_dpram_basic(dut):
        """Test basic read/write operations of dual-port RAM"""
        DW = int(dut.DW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        wr_clk = dut.wr_clk
        wr_ce = dut.wr_ce
        wr_we = dut.wr_we
        wr_wmask = dut.wr_wmask
        wr_addr = dut.wr_addr
        wr_din = dut.wr_din
        rd_clk = dut.rd_clk
        rd_ce = dut.rd_ce
        rd_addr = dut.rd_addr
        ctrl = dut.ctrl

        # Initialize
        wr_ce.value = 0
        wr_we.value = 0
        wr_wmask.value = 0
        wr_addr.value = 0
        wr_din.value = 0
        rd_ce.value = 0
        rd_addr.value = 0
        ctrl.value = CTRL_VALUE
        dut.selctrl.value = 0

        # Start clocks using cocotb Clock
        cocotb.start_soon(Clock(wr_clk, clk_period_ns, unit="ns").start())
        cocotb.start_soon(Clock(rd_clk, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Run tests
        await write_operations(dut, DW)
        await read_operations(dut, DW)

    @cocotb.test()
    async def test_la_dpram_all_addresses(dut):
        """Test all address coverage for dual-port RAM"""
        DW = int(dut.DW.value)
        AW = int(dut.AW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        wr_clk = dut.wr_clk
        wr_ce = dut.wr_ce
        wr_we = dut.wr_we
        wr_wmask = dut.wr_wmask
        wr_addr = dut.wr_addr
        wr_din = dut.wr_din
        rd_clk = dut.rd_clk
        rd_ce = dut.rd_ce
        rd_addr = dut.rd_addr
        ctrl = dut.ctrl

        # Initialize
        wr_ce.value = 0
        wr_we.value = 0
        wr_wmask.value = 0
        wr_addr.value = 0
        wr_din.value = 0
        rd_ce.value = 0
        rd_addr.value = 0
        ctrl.value = CTRL_VALUE
        dut.selctrl.value = 0

        # Start clocks using cocotb Clock
        cocotb.start_soon(Clock(wr_clk, clk_period_ns, unit="ns").start())
        cocotb.start_soon(Clock(rd_clk, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Run comprehensive test
        await all_addresses(dut, DW, AW)


else:
    def test_la_dpram_basic():
        """Placeholder test when cocotb is not installed."""
        pass

    def test_la_dpram_all_addresses():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):
    """SiliconCompiler Design wrapper for la_dpram cocotb testbench."""

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
            name = f"cocotb_test_la_dpram_dw{dw}_aw{aw}_ctrl{ctrl}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_dpram_impl")
                self.add_depfileset(Dpram(), "rtl")
                self.set_param("DW", str(dw))
                self.set_param("AW", str(aw))

                if simulator in ["icarus", "verilator"]:
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_dpram_test.py", filetype="python")


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
