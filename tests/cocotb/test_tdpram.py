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
        
        # Get the data width and address width from the DUT signals
        dw = len(dut.din_a)
        aw = len(dut.addr_a)
        max_dw_value = (1 << dw) - 1
        max_addr = (1 << aw) - 1
        
        # Adapt test values to the actual data width
        test_val_a = (0xDEAD0000 & max_dw_value)
        test_val_b = (0xBEEFBEEF & max_dw_value)
        
        # Use safe addresses within the address width
        addr_a1 = min(15, max_addr // 2)
        addr_a2 = min(25, max_addr - 1)
        addr_b1 = min(20, max_addr - 2)
        
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
        
        # Test 1: Port A writes to addr, Port B simultaneous reads from different addr
        dut.addr_a.value = addr_a1
        dut.din_a.value = test_val_a
        dut.wmask_a.value = max_dw_value
        dut.ce_a.value = 1
        dut.we_a.value = 1
        
        dut.addr_b.value = addr_b1
        dut.ce_b.value = 1
        dut.we_b.value = 0  # Read
        
        await ClockCycles(dut.clk_a, 1)
        
        # Clear write on A
        dut.we_a.value = 0
        dut.ce_a.value = 0
        
        # Test 2: Port B writes while Port A reads
        dut.addr_a.value = addr_a1
        dut.ce_a.value = 1
        dut.we_a.value = 0  # Read
        
        dut.addr_b.value = addr_a2
        dut.din_b.value = test_val_b
        dut.wmask_b.value = max_dw_value
        dut.ce_b.value = 1
        dut.we_b.value = 1
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        assert read_a == test_val_a, f"Port A read mismatch: got 0x{read_a:X}, expected 0x{test_val_a:X}"
        
        dut.ce_a.value = 0
        dut.ce_b.value = 0
        dut.we_b.value = 0
        
        # Test 3: Both ports read different locations
        dut.addr_a.value = addr_a1
        dut.ce_a.value = 1
        dut.we_a.value = 0
        
        dut.addr_b.value = addr_a2
        dut.ce_b.value = 1
        dut.we_b.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        read_b = int(dut.dout_b.value)
        
        assert read_a == test_val_a, f"Port A final read mismatch: got 0x{read_a:X}, expected 0x{test_val_a:X}"
        assert read_b == test_val_b, f"Port B final read mismatch: got 0x{read_b:X}, expected 0x{test_val_b:X}"

    @cocotb.test()
    async def test_tdpram_port_isolation(dut):
        """Test TDPRAM port isolation with independent writes"""
        
        # Get the data width and address width from the DUT signals
        dw = len(dut.din_a)
        aw = len(dut.addr_a)
        max_dw_value = (1 << dw) - 1
        max_addr = (1 << aw) - 1
        
        # Adapt test values to the actual data width
        test_val_a = (0x11111111 & max_dw_value)
        test_val_b = (0x22222222 & max_dw_value)
        
        # Use safe addresses within the address width
        addr_a = min(100 & max_addr, max_addr // 2)
        addr_b = min(200 & max_addr, max_addr - 1)
        
        # Setup clocks
        clk_a = Clock(dut.clk_a, 10, unit="ns")
        clk_b = Clock(dut.clk_b, 10, unit="ns")
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
        
        # Port A writes to address
        dut.addr_a.value = addr_a
        dut.din_a.value = test_val_a
        dut.wmask_a.value = max_dw_value
        dut.ce_a.value = 1
        dut.we_a.value = 1
        
        await ClockCycles(dut.clk_a, 1)
        
        # Port B writes to different address
        dut.addr_b.value = addr_b
        dut.din_b.value = test_val_b
        dut.wmask_b.value = max_dw_value
        dut.ce_b.value = 1
        dut.we_b.value = 1
        
        await ClockCycles(dut.clk_a, 1)
        
        # Both ports clear
        dut.we_a.value = 0
        dut.we_b.value = 0
        dut.ce_a.value = 0
        dut.ce_b.value = 0
        
        await ClockCycles(dut.clk_a, 1)
        
        # Port A reads address
        dut.addr_a.value = addr_a
        dut.ce_a.value = 1
        dut.we_a.value = 0
        
        await ClockCycles(dut.clk_a, 2)
        
        read_a = int(dut.dout_a.value)
        assert read_a == test_val_a, f"Port A isolation failed: got 0x{read_a:X}, expected 0x{test_val_a:X}"
        
        dut.ce_a.value = 0
