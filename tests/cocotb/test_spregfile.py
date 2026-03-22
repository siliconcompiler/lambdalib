"""
SPREGFILE functional test using cocotb.

Tests basic single-port register file read/write operations with data verification.
"""

try:
    import cocotb
    import os
    from cocotb.clock import Clock
    from cocotb.triggers import ClockCycles, Timer
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False


if _has_cocotb:
    @cocotb.test()
    async def test_spregfile_basic_operations(dut):
        """Test basic SPREGFILE read/write operations"""

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

        await ClockCycles(dut.clk, 2)  # Register file has read latency

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
    async def test_spregfile_write_mask(dut):
        """Test SPREGFILE partial write masking"""

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

    @cocotb.test()
    async def test_spregfile_address_timing(dut):
        """Test SPREGFILE timing - address must be stable during read pipeline.
        
        This test exposes timing bugs where address changes between clock cycles
        during a read operation. The address selection should be LATCHED on the rising
        clock edge (using selected_reg) to maintain stable output. Changing the address
        mid-cycle should not affect the data currently in the pipeline.
        
        BUG CONDITION: If the template uses combinatorial 'selected' instead of 
        'selected_reg' in the address decoder, the output multiplexer will use 
        the current address combinatorially instead of the latched address.
        """

        # Setup clock (10ns period = 5ns half-cycle)
        clock = Clock(dut.clk, 10, unit="ns")
        cocotb.start_soon(clock.start())

        # Get the data width from the DUT parameter
        dw = len(dut.din)
        max_value = (1 << dw) - 1
        aw = len(dut.addr)
        macroaw = int(os.getenv("COCOTB_MACROAW", "0"))

        if macroaw >= aw:
            return # Skip test if macroaw is too large for the address width

        # Initialize
        dut.ce.value = 0
        dut.we.value = 0
        dut.wmask.value = 0
        dut.addr.value = 0
        dut.din.value = 0

        await ClockCycles(dut.clk, 2)

        # Pre-write VERY DIFFERENT values to multiple addresses
        test_val_addr0 = 0xAAAA & max_value
        test_addr0 = 0
        test_val_addr1 = 0x5555 & max_value
        test_addr1 = 2**(macroaw)

        # Write to multiple addresses to ensure different memory locations
        for addr, val in [(test_addr0, test_val_addr0), (test_addr1, test_val_addr1)]:
            dut.addr.value = addr
            dut.din.value = val
            dut.wmask.value = max_value
            dut.ce.value = 1
            dut.we.value = 1
            await ClockCycles(dut.clk, 1)

        dut.we.value = 0
        dut.ce.value = 0
        await ClockCycles(dut.clk, 1)

        # CRITICAL TIMING TEST: Address changes mid-cycle
        dut.addr.value = test_addr0
        dut.ce.value = 1

        # Clock N: Setup address 0 read
        await ClockCycles(dut.clk, 1)
        await Timer(1, unit="ns")
        read_value0 = int(dut.dout.value)

        # CRITICAL: Address changes AFTER rising edge but BEFORE next rising edge
        await Timer(5, unit="ns")
        dut.addr.value = test_addr1
        await Timer(1, unit="ns")
        read_value0a = int(dut.dout.value)

        # Clock N+1: Let the change settle and next things latch
        await ClockCycles(dut.clk, 1)
        await Timer(1, unit="ns")
        read_value1 = int(dut.dout.value)
        await ClockCycles(dut.clk, 1)

        # ASSERTION MUST FAIL with the bug present
        assert read_value0 == test_val_addr0, \
            f"TIMING BUG DETECTED in SPREGFILE template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr0:X} (from address 0, which was latched)\n"
        assert read_value0 == read_value0a, \
            f"TIMING BUG DETECTED in SPREGFILE template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{read_value0a:X} (from address 0, which was latched)\n"
        assert read_value1 == test_val_addr1, \
            f"TIMING BUG DETECTED in SPREGFILE template:\n" \
            f"  Got: 0x{read_value1:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr1:X} (from address 1, which was latched)\n"

        dut.ce.value = 0
