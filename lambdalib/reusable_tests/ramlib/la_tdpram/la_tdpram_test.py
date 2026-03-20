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
from lambdalib.ramlib import Tdpram


if _has_cocotb:

    async def wait_cycles(clk, n):
        """Wait for n clock cycles by monitoring clock edges"""
        for _ in range(n):
            await cocotb.triggers.RisingEdge(clk)

    async def test_port_a_write(dut, DW):
        """Test Port A write operations"""
        clk_a = dut.clk_a
        ce_a = dut.ce_a
        we_a = dut.we_a
        wmask_a = dut.wmask_a
        addr_a = dut.addr_a
        din_a = dut.din_a

        # Setup Port A for writing
        ce_a.value = 1
        wmask_a.value = (1 << DW) - 1
        we_a.value = 1

        # Write 0xAAAA to address 0 on port A
        addr_a.value = 0
        din_a.value = 0xAAAA & ((1 << DW) - 1)
        await wait_cycles(clk_a, 1)

        # Write 0x5555 to address 1 on port A
        addr_a.value = 1
        din_a.value = 0x5555 & ((1 << DW) - 1)
        await wait_cycles(clk_a, 1)

        # Disable writes before returning
        we_a.value = 0

    async def test_port_b_write(dut, DW):
        """Test Port B write operations"""
        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        wmask_b = dut.wmask_b
        addr_b = dut.addr_b
        din_b = dut.din_b

        # Setup Port B for writing
        ce_b.value = 1
        wmask_b.value = (1 << DW) - 1
        we_b.value = 1

        # Write 0x3333 to address 2 on port B
        addr_b.value = 2
        din_b.value = 0x3333 & ((1 << DW) - 1)
        await wait_cycles(clk_b, 1)

        # Write 0x7777 to address 3 on port B
        addr_b.value = 3
        din_b.value = 0x7777 & ((1 << DW) - 1)
        await wait_cycles(clk_b, 1)

        # Disable writes before returning
        we_b.value = 0

    async def test_port_a_read(dut, DW):
        """Test Port A read operations"""
        clk_a = dut.clk_a
        ce_a = dut.ce_a
        we_a = dut.we_a
        addr_a = dut.addr_a
        dout_a = dut.dout_a

        # Set up read mode for Port A
        we_a.value = 0
        ce_a.value = 1
        addr_a.value = 0
        await wait_cycles(clk_a, 2)  # Wait for read setup

        # Read from address 0 on port A
        await wait_cycles(clk_a, 2)
        assert dout_a.value == (0xAAAA & ((1 << DW) - 1)), \
            f"Port A read addr 0 failed: {hex(dout_a.value)}"

        # Read from address 1 on port A
        addr_a.value = 1
        await wait_cycles(clk_a, 2)
        assert dout_a.value == (0x5555 & ((1 << DW) - 1)), \
            f"Port A read addr 1 failed: {hex(dout_a.value)}"

    async def test_port_b_read(dut, DW):
        """Test Port B read operations"""
        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        addr_b = dut.addr_b
        dout_b = dut.dout_b

        # Set up read mode for Port B
        we_b.value = 0
        ce_b.value = 1
        addr_b.value = 2
        await wait_cycles(clk_b, 2)  # Wait for read setup

        # Read from address 2 on port B
        await wait_cycles(clk_b, 2)
        assert dout_b.value == (0x3333 & ((1 << DW) - 1)), \
            f"Port B read addr 2 failed: {hex(dout_b.value)}"

        # Read from address 3 on port B
        addr_b.value = 3
        await wait_cycles(clk_b, 2)
        assert dout_b.value == (0x7777 & ((1 << DW) - 1)), \
            f"Port B read addr 3 failed: {hex(dout_b.value)}"

    async def test_port_b_write_and_read(dut, DW):
        """Test Port B write-and-read sequence within Port B clock domain"""
        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        wmask_b = dut.wmask_b
        addr_b = dut.addr_b
        din_b = dut.din_b
        dout_b = dut.dout_b
        data_mask = (1 << DW) - 1

        # Initialize - clear addresses 4 and 5 first
        ce_b.value = 1
        wmask_b.value = data_mask
        we_b.value = 1

        # Clear address 4
        addr_b.value = 4
        din_b.value = 0
        await wait_cycles(clk_b, 1)

        # Clear address 5
        addr_b.value = 5
        din_b.value = 0
        await wait_cycles(clk_b, 1)

        # Write test data to address 4
        addr_b.value = 4
        din_b.value = 0xBEEF & data_mask
        await wait_cycles(clk_b, 1)

        # Write test data to address 5
        addr_b.value = 5
        din_b.value = 0xDEAD & data_mask
        await wait_cycles(clk_b, 1)

        # Switch to read mode
        we_b.value = 0
        await wait_cycles(clk_b, 1)

        # Read back from address 4 and verify
        addr_b.value = 4
        await wait_cycles(clk_b, 2)
        assert dout_b.value == (0xBEEF & data_mask), \
            f"Port B write-read addr 4 failed: {hex(dout_b.value)}"

        # Read back from address 5 and verify
        addr_b.value = 5
        await wait_cycles(clk_b, 2)
        assert dout_b.value == (0xDEAD & data_mask), \
            f"Port B write-read addr 5 failed: {hex(dout_b.value)}"

    async def test_all_addresses(dut, DW, AW):
        """Test write and read from all addresses on both ports"""
        clk_a = dut.clk_a
        ce_a = dut.ce_a
        we_a = dut.we_a
        wmask_a = dut.wmask_a
        addr_a = dut.addr_a
        din_a = dut.din_a
        dout_a = dut.dout_a

        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        wmask_b = dut.wmask_b
        addr_b = dut.addr_b
        dout_b = dut.dout_b

        depth = 2 ** AW
        data_mask = (1 << DW) - 1

        # Setup: Disable all operations initially
        we_a.value = 0
        we_b.value = 0
        ce_a.value = 1
        ce_b.value = 1
        wmask_a.value = data_mask
        wmask_b.value = data_mask

        # Clear entire memory from Port A only (simplifies data handling)
        we_a.value = 1
        for clear_addr in range(depth):
            addr_a.value = clear_addr
            din_a.value = 0
            await wait_cycles(clk_a, 1)

        # Disable Port A writes and wait
        we_a.value = 0
        await wait_cycles(clk_a, 2)

        # Write all addresses from Port A with test pattern
        we_a.value = 1
        for test_addr in range(depth):
            addr_a.value = test_addr
            test_pattern = (test_addr * 0x1111) & data_mask
            din_a.value = test_pattern
            await wait_cycles(clk_a, 1)

        # Disable Port A writes and wait
        we_a.value = 0
        await wait_cycles(clk_a, 3)

        # Read back from Port A and verify all addresses
        addr_a.value = 0
        await wait_cycles(clk_a, 3)  # Prime first read
        for test_addr in range(depth):
            addr_a.value = test_addr
            await wait_cycles(clk_a, 2)
            expected_pattern = (test_addr * 0x1111) & data_mask
            assert dout_a.value == expected_pattern, \
                f"Port A address {test_addr} mismatch: got {hex(dout_a.value)}, " \
                f"expected {hex(expected_pattern)}"

        # Also verify all addresses can be read from Port B
        addr_b.value = 0
        await wait_cycles(clk_b, 3)  # Prime first read
        for test_addr in range(depth):
            addr_b.value = test_addr
            await wait_cycles(clk_b, 2)
            expected_pattern = (test_addr * 0x1111) & data_mask
            assert dout_b.value == expected_pattern, \
                f"Port B address {test_addr} mismatch: got {hex(dout_b.value)}, " \
                f"expected {hex(expected_pattern)}"

    @cocotb.test()
    async def test_la_tdpram_basic(dut):
        """Test basic read/write operations of true dual-port RAM"""
        DW = int(dut.DW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        # Port A
        clk_a = dut.clk_a
        ce_a = dut.ce_a
        we_a = dut.we_a
        wmask_a = dut.wmask_a
        addr_a = dut.addr_a
        din_a = dut.din_a

        # Port B
        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        wmask_b = dut.wmask_b
        addr_b = dut.addr_b
        din_b = dut.din_b
        ctrl = dut.ctrl

        # Initialize
        ce_a.value = 0
        we_a.value = 0
        wmask_a.value = 0
        addr_a.value = 0
        din_a.value = 0
        ce_b.value = 0
        we_b.value = 0
        wmask_b.value = 0
        addr_b.value = 0
        din_b.value = 0
        ctrl.value = CTRL_VALUE

        # Start clocks using cocotb Clock
        cocotb.start_soon(Clock(clk_a, clk_period_ns, unit="ns").start())
        cocotb.start_soon(Clock(clk_b, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Test basic Port A write operation
        await test_port_a_write(dut, DW)

        # Test Port B write and read-back within Port B's clock domain
        # This exercises we_b, din_b, data_out_b and verifies data integrity
        await test_port_b_write_and_read(dut, DW)

    @cocotb.test()
    async def test_la_tdpram_all_addresses(dut):
        """Test all address coverage for true dual-port RAM"""
        DW = int(dut.DW.value)
        AW = int(dut.AW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        # Port A
        clk_a = dut.clk_a
        ce_a = dut.ce_a
        we_a = dut.we_a
        wmask_a = dut.wmask_a
        addr_a = dut.addr_a
        din_a = dut.din_a

        # Port B
        clk_b = dut.clk_b
        ce_b = dut.ce_b
        we_b = dut.we_b
        wmask_b = dut.wmask_b
        addr_b = dut.addr_b
        din_b = dut.din_b
        ctrl = dut.ctrl

        # Initialize
        ce_a.value = 0
        we_a.value = 0
        wmask_a.value = 0
        addr_a.value = 0
        din_a.value = 0
        ce_b.value = 0
        we_b.value = 0
        wmask_b.value = 0
        addr_b.value = 0
        din_b.value = 0
        ctrl.value = CTRL_VALUE

        # Start clocks using cocotb Clock
        cocotb.start_soon(Clock(clk_a, clk_period_ns, unit="ns").start())
        cocotb.start_soon(Clock(clk_b, clk_period_ns, unit="ns").start())
        await Timer(clk_period_ns, unit="ns")

        # Run comprehensive test
        await test_all_addresses(dut, DW, AW)


else:
    def test_la_tdpram_basic():
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
            name = f"cocotb_test_la_tdpram_dw{dw}_aw{aw}_ctrl{ctrl}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_tdpram_impl")
                self.add_depfileset(Tdpram(), "rtl")
                self.set_param("DW", str(dw))
                self.set_param("AW", str(aw))

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_tdpram_test.py", filetype="python")


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
