"""
SPRAM functional test using cocotb.

Tests basic SPRAM read/write operations with data verification.
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
    async def test_spram_basic_operations(dut):
        """Test basic SPRAM read/write operations"""
        
        # Setup clock
        clock = Clock(dut.clk, 10, unit="ns")
        cocotb.start_soon(clock.start())
        
        # Initialize all signals
        dut.ce.value = 0
        dut.we.value = 0
        dut.wmask.value = 0
        dut.addr.value = 0
        dut.din.value = 0
        
        await ClockCycles(dut.clk, 2)
        
        # Test 1: Write to address 0
        dut.addr.value = 0
        dut.din.value = 0xDEADBEEF
        dut.wmask.value = 0xFFFFFFFF  # All bits enabled (32-bit mask)
        dut.ce.value = 1
        dut.we.value = 1
        
        await ClockCycles(dut.clk, 1)
        
        # Clear write signals
        dut.we.value = 0
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)
        
        # Test 2: Write to address 1
        dut.addr.value = 1
        dut.din.value = 0xCAFECAFE
        dut.wmask.value = 0xFFFFFFFF  # All bits enabled (32-bit mask)
        dut.ce.value = 1
        dut.we.value = 1
        
        await ClockCycles(dut.clk, 1)
        
        dut.we.value = 0
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)
        
        # Test 3: Read from address 0
        dut.addr.value = 0
        dut.ce.value = 1
        dut.we.value = 0  # Read mode
        
        await ClockCycles(dut.clk, 2)  # SPRAM has read latency
        
        # Verify read data (SOFT implementation may have different latency)
        read_value = int(dut.dout.value)
        assert read_value == 0xDEADBEEF, f"Read mismatch at addr 0: got 0x{read_value:08X}, expected 0xDEADBEEF"
        
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)
        
        # Test 4: Read from address 1
        dut.addr.value = 1
        dut.ce.value = 1
        dut.we.value = 0
        
        await ClockCycles(dut.clk, 2)
        
        read_value = int(dut.dout.value)
        assert read_value == 0xCAFECAFE, f"Read mismatch at addr 1: got 0x{read_value:08X}, expected 0xCAFECAFE"
        
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)

    @cocotb.test()
    async def test_spram_write_mask(dut):
        """Test SPRAM partial write masking"""
        
        # Setup clock
        clock = Clock(dut.clk, 10, unit="ns")
        cocotb.start_soon(clock.start())
        
        # Initialize
        dut.ce.value = 0
        dut.we.value = 0
        dut.wmask.value = 0
        dut.addr.value = 0
        dut.din.value = 0
        
        await ClockCycles(dut.clk, 2)
        
        # Write full word first
        dut.addr.value = 5
        dut.din.value = 0xFFFFFFFF
        dut.wmask.value = 0xFFFFFFFF  # All bytes enabled (32-bit mask with all bits set)
        dut.ce.value = 1
        dut.we.value = 1
        dut.ce.value = 1
        dut.we.value = 1
        
        await ClockCycles(dut.clk, 1)
        
        dut.we.value = 0
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)
        
        # Partial write - only upper byte (byte 3, mask bits [31:24])
        dut.addr.value = 5
        dut.din.value = 0x12340000
        dut.wmask.value = 0xFF000000  # Only byte 3 (bits [31:24])
        dut.ce.value = 1
        dut.we.value = 1
        
        await ClockCycles(dut.clk, 1)
        
        dut.we.value = 0
        dut.ce.value = 0
        
        await ClockCycles(dut.clk, 1)
        
        # Read back - should have upper byte from second write and lower 3 bytes from first
        dut.addr.value = 5
        dut.ce.value = 1
        dut.we.value = 0
        
        await ClockCycles(dut.clk, 2)
        
        read_value = int(dut.dout.value)
        expected = 0x12FFFFFF
        assert read_value == expected, f"Partial write mask failed: got 0x{read_value:08X}, expected 0x{expected:08X}"
        
        dut.ce.value = 0
