"""
TDPRAM functional test using cocotb.

Tests true dual-port RAM with simultaneous operations on both ports.
"""

try:
    import cocotb
    from cocotb.clock import Clock
    from cocotb.triggers import ClockCycles
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False


if _has_cocotb:
    @cocotb.test()
    async def test_tdpram_simultaneous_ops(dut):
        """Test TDPRAM with simultaneous read/write on both ports"""
        
        # Setup clocks for both ports
        clk_a = Clock(dut.clk_a, 10, unit="ns")
        clk_b = Clock(dut.clk_b, 10, unit="ns")
        cocotb.start_soon(clk_a.start())
        cocotb.start_soon(clk_b.start())
        
        # Initialize port A
        dut.ce_a.value = 0
        dut.we_a.value = 0
        dut.wmask_a.value = 0
        dut.addr_a.value = 0
        dut.din_a.value = 0
        
        # Initialize port B
        dut.ce_b.value = 0
        dut.we_b.value = 0
        dut.wmask_b.value = 0
        dut.addr_b.value = 0
        dut.din_b.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        # Test 1: Port A writes to addr 15, Port B simultaneous reads from addr 20
        dut.addr_a.value = 15
        dut.din_a.value = 0xDEAD0000
        dut.wmask_a.value = 0xFFFFFFFF
        dut.ce_a.value = 1
        dut.we_a.value = 1
        
        dut.addr_b.value = 20
        dut.ce_b.value = 1
        dut.we_b.value = 0  # Read
        
        await ClockCycles(dut.clk_a, 1)
        
        # Clear write on A
        dut.we_a.value = 0
        dut.ce_a.value = 0
        
        # Test 2: Port B writes while Port A reads
        dut.addr_a.value = 15
        dut.ce_a.value = 1
        dut.we_a.value = 0  # Read
        
        dut.addr_b.value = 25
        dut.din_b.value = 0xBEEFBEEF
        dut.wmask_b.value = 0xFFFFFFFF
        dut.ce_b.value = 1
        dut.we_b.value = 1
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        assert read_a == 0xDEAD0000, f"Port A read mismatch: got 0x{read_a:08X}"
        
        dut.ce_a.value = 0
        dut.ce_b.value = 0
        dut.we_b.value = 0
        
        # Test 3: Both ports read different locations
        dut.addr_a.value = 15
        dut.ce_a.value = 1
        dut.we_a.value = 0
        
        dut.addr_b.value = 25
        dut.ce_b.value = 1
        dut.we_b.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        read_b = int(dut.dout_b.value)
        
        assert read_a == 0xDEAD0000, f"Port A final read mismatch: got 0x{read_a:08X}"
        assert read_b == 0xBEEFBEEF, f"Port B final read mismatch: got 0x{read_b:08X}"

    @cocotb.test()
    async def test_tdpram_port_isolation(dut):
        """Test TDPRAM port isolation with independent writes"""
        
        # Setup clocks
        clk_a = Clock(dut.clk_a, 10, units="ns")
        clk_b = Clock(dut.clk_b, 10, units="ns")
        cocotb.start_soon(clk_a.start())
        cocotb.start_soon(clk_b.start())
        
        # Initialize
        dut.ce_a.value = 0
        dut.we_a.value = 0
        dut.wmask_a.value = 0
        dut.addr_a.value = 0
        dut.din_a.value = 0
        dut.ce_b.value = 0
        dut.we_b.value = 0
        dut.wmask_b.value = 0
        dut.addr_b.value = 0
        dut.din_b.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        # Port A writes to address 100
        dut.addr_a.value = 100
        dut.din_a.value = 0x11111111
        dut.wmask_a.value = 0xFFFFFFFF
        dut.ce_a.value = 1
        dut.we_a.value = 1
        
        await ClockCycles(dut.clk_a, 1)
        
        # Port B writes to address 200
        dut.addr_b.value = 200
        dut.din_b.value = 0x22222222
        dut.wmask_b.value = 0xFFFFFFFF
        dut.ce_b.value = 1
        dut.we_b.value = 1
        
        await ClockCycles(dut.clk_a, 1)
        
        # Both ports clear
        dut.we_a.value = 0
        dut.we_b.value = 0
        dut.ce_a.value = 0
        dut.ce_b.value = 0
        
        await ClockCycles(dut.clk_a, 1)
        
        # Port A reads address 100
        dut.addr_a.value = 100
        dut.ce_a.value = 1
        dut.we_a.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        assert read_a == 0x11111111, f"Port A isolation failed: got 0x{read_a:08X}"
        
        dut.ce_a.value = 0
