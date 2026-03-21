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

        # Get the data width from the DUT parameter
        dw = len(dut.din)
        max_value = (1 << dw) - 1

        # Initialize all signals
        dut.ce.value = 0
        dut.we.value = 0
        dut.wmask.value = 0
        dut.addr.value = 0
        dut.din.value = 0

        await ClockCycles(dut.clk, 2)

        # Test 1: Write to address 0
        dut.addr.value = 0
        test_val1 = (0xDEADBEEF & max_value) if dw >= 32 else (0xBEEF & max_value)
        dut.din.value = test_val1
        dut.wmask.value = max_value  # All bits enabled
        dut.ce.value = 1
        dut.we.value = 1

        await ClockCycles(dut.clk, 1)

        # Clear write signals
        dut.we.value = 0
        dut.ce.value = 0

        await ClockCycles(dut.clk, 1)

        # Test 2: Write to address 1
        dut.addr.value = 1
        test_val2 = (0xCAFECAFE & max_value) if dw >= 32 else (0xCAFE & max_value)
        dut.din.value = test_val2
        dut.wmask.value = max_value  # All bits enabled
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

        # Verify read data
        read_value = int(dut.dout.value)
        assert read_value == test_val1, f"Read mismatch at addr 0: got 0x{read_value:X}, expected 0x{test_val1:X}"

        dut.ce.value = 0

        await ClockCycles(dut.clk, 1)

        # Test 4: Read from address 1
        dut.addr.value = 1
        dut.ce.value = 1
        dut.we.value = 0

        await ClockCycles(dut.clk, 2)

        read_value = int(dut.dout.value)
        assert read_value == test_val2, f"Read mismatch at addr 1: got 0x{read_value:X}, expected 0x{test_val2:X}"

        dut.ce.value = 0

        await ClockCycles(dut.clk, 1)

    @cocotb.test()
    async def test_spram_write_mask(dut):
        """Test SPRAM partial write masking"""

        # Setup clock
        clock = Clock(dut.clk, 10, unit="ns")
        cocotb.start_soon(clock.start())

        # Get the data width from the DUT parameter
        dw = len(dut.din)
        max_value = (1 << dw) - 1

        # Initialize
        dut.ce.value = 0
        dut.we.value = 0
        dut.wmask.value = 0
        dut.addr.value = 0
        dut.din.value = 0

        await ClockCycles(dut.clk, 2)

        # Write full word first
        dut.addr.value = 5
        dut.din.value = max_value  # All bits set
        dut.wmask.value = max_value  # All bits enabled
        dut.ce.value = 1
        dut.we.value = 1

        await ClockCycles(dut.clk, 1)

        dut.we.value = 0
        dut.ce.value = 0

        await ClockCycles(dut.clk, 1)

        # Partial write - only upper bits (top 1/4 of bits)
        dut.addr.value = 5
        upper_mask = max_value & (max_value << (dw // 4)) if dw >= 4 else max_value >> 1
        dut.din.value = 0x1234 & max_value
        dut.wmask.value = upper_mask
        dut.ce.value = 1
        dut.we.value = 1

        await ClockCycles(dut.clk, 1)

        dut.we.value = 0
        dut.ce.value = 0

        await ClockCycles(dut.clk, 1)

        # Read back - should have partial write applied
        dut.addr.value = 5
        dut.ce.value = 1
        dut.we.value = 0

        await ClockCycles(dut.clk, 2)

        read_value = int(dut.dout.value)
        expected = (0x1234 & upper_mask) | (max_value & ~upper_mask)
        assert read_value == expected, f"Partial write mask failed: got 0x{read_value:X}, expected 0x{expected:X}"

        dut.ce.value = 0
