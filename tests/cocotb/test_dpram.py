"""
DPRAM functional test using cocotb.

Tests DPRAM with independent read/write clock domains.
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
    async def test_dpram_independent_clocks(dut):
        """Test DPRAM with different write and read clock frequencies"""
        
        # Get the data width from the DUT signals
        dw = len(dut.wr_din)
        max_value = (1 << dw) - 1
        
        # Adapt test values to the actual data width
        test_val1 = (0xABCDEF01 & max_value)
        test_val2 = (0x12345678 & max_value)
        
        # Setup independent clocks
        wr_clock = Clock(dut.wr_clk, 10, unit="ns")
        rd_clock = Clock(dut.rd_clk, 14, unit="ns")
        cocotb.start_soon(wr_clock.start())
        cocotb.start_soon(rd_clock.start())
        
        # Initialize write side
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        dut.wr_wmask.value = 0
        dut.wr_addr.value = 0
        dut.wr_din.value = 0
        
        # Initialize read side
        dut.rd_ce.value = 0
        dut.rd_addr.value = 0
        
        await ClockCycles(dut.wr_clk, 2)
        
        # Test 1: Write on write clock
        dut.wr_addr.value = 10
        dut.wr_din.value = test_val1
        dut.wr_wmask.value = max_value
        dut.wr_ce.value = 1
        dut.wr_we.value = 1
        
        await ClockCycles(dut.wr_clk, 1)
        
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        
        # Write another value
        dut.wr_addr.value = 20
        dut.wr_din.value = test_val2
        dut.wr_wmask.value = max_value
        dut.wr_ce.value = 1
        dut.wr_we.value = 1
        
        await ClockCycles(dut.wr_clk, 1)
        
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        
        # Test 2: Read on read clock (continues independently)
        dut.rd_addr.value = 10
        dut.rd_ce.value = 1
        
        await ClockCycles(dut.rd_clk, 2)
        
        read_value = int(dut.rd_dout.value)
        assert read_value == test_val1, f"DPRAM read mismatch: got 0x{read_value:X}, expected 0x{test_val1:X}"
        
        dut.rd_ce.value = 0
        
        await ClockCycles(dut.rd_clk, 1)
        
        # Read second value
        dut.rd_addr.value = 20
        dut.rd_ce.value = 1
        
        await ClockCycles(dut.rd_clk, 2)
        
        read_value = int(dut.rd_dout.value)
        assert read_value == test_val2, f"DPRAM read mismatch: got 0x{read_value:X}, expected 0x{test_val2:X}"

    @cocotb.test()
    async def test_dpram_write_read_same_addr(dut):
        """Test DPRAM simultaneous write and read to different addresses"""
        
        # Get the data width from the DUT signals
        dw = len(dut.wr_din)
        max_value = (1 << dw) - 1
        
        # Adapt test value to the actual data width
        test_val = (0xDEADBEEF & max_value)
        
        # Setup independent clocks
        wr_clock = Clock(dut.wr_clk, 10, unit="ns")
        rd_clock = Clock(dut.rd_clk, 10, unit="ns")
        cocotb.start_soon(wr_clock.start())
        cocotb.start_soon(rd_clock.start())
        
        # Initialize
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        dut.wr_wmask.value = 0
        dut.wr_addr.value = 0
        dut.wr_din.value = 0
        dut.rd_ce.value = 0
        dut.rd_addr.value = 0
        
        await ClockCycles(dut.wr_clk, 2)
        
        # Simultaneous write on A, read from B
        dut.wr_addr.value = 7
        dut.wr_din.value = test_val
        dut.wr_wmask.value = max_value
        dut.wr_ce.value = 1
        dut.wr_we.value = 1
        
        dut.rd_addr.value = 3
        dut.rd_ce.value = 1
        
        await ClockCycles(dut.wr_clk, 1)
        
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        dut.rd_ce.value = 0
        
        await ClockCycles(dut.wr_clk, 1)
