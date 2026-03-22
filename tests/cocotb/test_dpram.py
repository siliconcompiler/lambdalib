"""
DPRAM functional test using cocotb.

Tests DPRAM with independent read/write clock domains.
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
        assert read_value == test_val1, \
            f"DPRAM read mismatch: got 0x{read_value:X}, expected 0x{test_val1:X}"

        dut.rd_ce.value = 0

        await ClockCycles(dut.rd_clk, 1)

        # Read second value
        dut.rd_addr.value = 20
        dut.rd_ce.value = 1

        await ClockCycles(dut.rd_clk, 2)

        read_value = int(dut.rd_dout.value)
        assert read_value == test_val2, \
            f"DPRAM read mismatch: got 0x{read_value:X}, expected 0x{test_val2:X}"

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

    @cocotb.test()
    async def test_dpram_read_address_timing(dut):
        """Test DPRAM read path timing - address must be stable during read pipeline.

        This test exposes timing bugs on the read side where address changes between
        clock cycles affect the output selection. The address selection should be
        LATCHED on the rising clock edge to maintain stable output.

        BUG CONDITION: If the template uses combinatorial 'selected' instead of
        'selected_reg', the output multiplexer will use the current address
        combinatorially instead of the latched address.
        """

        # Setup clocks
        wr_clock = Clock(dut.wr_clk, 10, unit="ns")
        rd_clock = Clock(dut.rd_clk, 10, unit="ns")
        cocotb.start_soon(wr_clock.start())
        cocotb.start_soon(rd_clock.start())

        # Get the data width from the DUT signals
        dw = len(dut.wr_din)
        max_value = (1 << dw) - 1
        rd_aw = len(dut.rd_addr)
        macroaw = int(os.getenv("COCOTB_MACROAW", "0"))

        if macroaw >= rd_aw:
            return  # Skip test if macroaw is too large for the address width

        # Initialize
        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        dut.wr_wmask.value = 0
        dut.wr_addr.value = 0
        dut.wr_din.value = 0
        dut.rd_ce.value = 0
        dut.rd_addr.value = 0

        await ClockCycles(dut.wr_clk, 2)

        # Pre-write values to different read addresses
        test_val_addr0 = 0xAAAA & max_value
        test_addr0 = 0
        test_val_addr1 = 0x5555 & max_value
        test_addr1 = 2**(macroaw)

        # Write to multiple addresses
        for addr, val in [(test_addr0, test_val_addr0), (test_addr1, test_val_addr1)]:
            dut.wr_addr.value = addr
            dut.wr_din.value = val
            dut.wr_wmask.value = max_value
            dut.wr_ce.value = 1
            dut.wr_we.value = 1
            await ClockCycles(dut.wr_clk, 1)

        dut.wr_ce.value = 0
        dut.wr_we.value = 0
        await ClockCycles(dut.rd_clk, 1)

        # CRITICAL TIMING TEST on READ side: Address changes mid-cycle
        dut.rd_addr.value = test_addr0
        dut.rd_ce.value = 1

        # Clock N: Setup address 0 read
        await ClockCycles(dut.rd_clk, 1)
        await Timer(1, unit="ns")
        read_value0 = int(dut.rd_dout.value)

        # CRITICAL: Address changes AFTER rising edge but BEFORE next rising edge
        await Timer(5, unit="ns")
        dut.rd_addr.value = test_addr1
        await Timer(1, unit="ns")
        read_value0a = int(dut.rd_dout.value)

        # Clock N+1: Let the change settle and next things latch
        await ClockCycles(dut.rd_clk, 1)
        await Timer(1, unit="ns")
        read_value1 = int(dut.rd_dout.value)
        await ClockCycles(dut.rd_clk, 1)

        # ASSERTION MUST FAIL with the bug present
        assert read_value0 == test_val_addr0, \
            f"TIMING BUG DETECTED in DPRAM read template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr0:X} (from address 0, which was latched)\n"
        assert read_value0 == read_value0a, \
            f"TIMING BUG DETECTED in DPRAM read template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{read_value0a:X} (from address 0, which was latched)\n"
        assert read_value1 == test_val_addr1, \
            f"TIMING BUG DETECTED in DPRAM read template:\n" \
            f"  Got: 0x{read_value1:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr1:X} (from address 1, which was latched)\n"

        dut.rd_ce.value = 0
