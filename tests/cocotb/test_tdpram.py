"""
TDPRAM functional test using cocotb.

Tests true dual-port RAM with simultaneous operations on both ports.
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

    @cocotb.test()
    async def test_tdpram_port_a_timing(dut):
        """Test TDPRAM Port A timing - address must be stable during read pipeline.
        
        This test exposes timing bugs on Port A where address changes between
        clock cycles affect the output selection. The address selection should be
        LATCHED on the rising clock edge to maintain stable output.
        
        BUG CONDITION: If the template uses combinatorial 'selected' instead of 
        'selected_reg', the output multiplexer will use the current address
        combinatorially instead of the latched address.
        """

        # Setup clocks
        clk_a = Clock(dut.clk_a, 10, unit="ns")
        clk_b = Clock(dut.clk_b, 10, unit="ns")
        cocotb.start_soon(clk_a.start())
        cocotb.start_soon(clk_b.start())

        # Get the data width from the DUT signals
        dw = len(dut.din_a)
        max_value = (1 << dw) - 1
        addr_aw = len(dut.addr_a)
        macroaw = int(os.getenv("COCOTB_MACROAW", "0"))

        if macroaw >= addr_aw:
            return # Skip test if macroaw is too large for the address width

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

        # Pre-write values via Port A to different addresses
        test_val_addr0 = 0xAAAA & max_value
        test_addr0 = 0
        test_val_addr1 = 0x5555 & max_value
        test_addr1 = 2**(macroaw)

        # Write to multiple addresses via Port A
        for addr, val in [(test_addr0, test_val_addr0), (test_addr1, test_val_addr1)]:
            dut.addr_a.value = addr
            dut.din_a.value = val
            dut.wmask_a.value = max_value
            dut.ce_a.value = 1
            dut.we_a.value = 1
            await ClockCycles(dut.clk_a, 1)

        dut.we_a.value = 0
        dut.ce_a.value = 0
        await ClockCycles(dut.clk_a, 2)

        # CRITICAL TIMING TEST on Port A: Address changes mid-cycle
        dut.addr_a.value = test_addr0
        dut.ce_a.value = 1
        dut.we_a.value = 0

        # Clock N: Setup address 0 read - need 2 cycles for read latency
        await ClockCycles(dut.clk_a, 2)
        await Timer(1, unit="ns")
        read_value0 = int(dut.dout_a.value)

        # CRITICAL: Address changes AFTER rising edge but BEFORE next rising edge
        await Timer(5, unit="ns")
        dut.addr_a.value = test_addr1
        await Timer(1, unit="ns")
        read_value0a = int(dut.dout_a.value)

        # Clock N+1: Let the change settle and next things latch
        await ClockCycles(dut.clk_a, 2)
        await Timer(1, unit="ns")
        read_value1 = int(dut.dout_a.value)

        # ASSERTION MUST FAIL with the bug present
        assert read_value0 == test_val_addr0, \
            f"TIMING BUG DETECTED in TDPRAM Port A template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr0:X} (from address 0, which was latched)\n"
        assert read_value0 == read_value0a, \
            f"TIMING BUG DETECTED in TDPRAM Port A template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{read_value0a:X} (from address 0, which was latched)\n"
        assert read_value1 == test_val_addr1, \
            f"TIMING BUG DETECTED in TDPRAM Port A template:\n" \
            f"  Got: 0x{read_value1:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr1:X} (from address 1, which was latched)\n"

        dut.ce_a.value = 0

    @cocotb.test()
    async def test_tdpram_port_b_timing(dut):
        """Test TDPRAM Port B timing - address must be stable during read pipeline.
        
        This test exposes timing bugs on Port B where address changes between
        clock cycles affect the output selection. The address selection should be
        LATCHED on the rising clock edge to maintain stable output.
        
        BUG CONDITION: If the template uses combinatorial 'selected' instead of 
        'selected_reg', the output multiplexer will use the current address
        combinatorially instead of the latched address.
        """

        # Setup clocks
        clk_a = Clock(dut.clk_a, 10, unit="ns")
        clk_b = Clock(dut.clk_b, 10, unit="ns")
        cocotb.start_soon(clk_a.start())
        cocotb.start_soon(clk_b.start())

        # Get the data width from the DUT signals
        dw = len(dut.din_a)
        max_value = (1 << dw) - 1
        addr_aw = len(dut.addr_a)
        macroaw = int(os.getenv("COCOTB_MACROAW", "0"))

        if macroaw >= addr_aw:
            return # Skip test if macroaw is too large for the address width

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

        # Pre-write values via Port A to different addresses
        test_val_addr0 = 0xAAAA & max_value
        test_addr0 = 0
        test_val_addr1 = 0x5555 & max_value
        test_addr1 = 2**(macroaw)

        # Write to multiple addresses via Port B
        for addr, val in [(test_addr0, test_val_addr0), (test_addr1, test_val_addr1)]:
            dut.addr_b.value = addr
            dut.din_b.value = val
            dut.wmask_b.value = max_value
            dut.ce_b.value = 1
            dut.we_b.value = 1
            await ClockCycles(dut.clk_b, 1)

        dut.we_b.value = 0
        dut.ce_b.value = 0
        await ClockCycles(dut.clk_b, 2)

        # CRITICAL TIMING TEST on Port B: Address changes mid-cycle
        dut.addr_b.value = test_addr0
        dut.ce_b.value = 1
        dut.we_b.value = 0

        # Clock N: Setup address 0 read - need 2 cycles for read latency
        await ClockCycles(dut.clk_b, 2)
        await Timer(1, unit="ns")
        read_value0 = int(dut.dout_b.value)

        # CRITICAL: Address changes AFTER rising edge but BEFORE next rising edge
        await Timer(5, unit="ns")
        dut.addr_b.value = test_addr1
        await Timer(1, unit="ns")
        read_value0a = int(dut.dout_b.value)

        # Clock N+1: Let the change settle and next things latch
        await ClockCycles(dut.clk_b, 2)
        await Timer(1, unit="ns")
        read_value1 = int(dut.dout_b.value)

        # ASSERTION MUST FAIL with the bug present
        assert read_value0 == test_val_addr0, \
            f"TIMING BUG DETECTED in TDPRAM Port B template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr0:X} (from address 0, which was latched)\n"
        assert read_value0 == read_value0a, \
            f"TIMING BUG DETECTED in TDPRAM Port B template:\n" \
            f"  Got: 0x{read_value0:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{read_value0a:X} (from address 0, which was latched)\n"
        assert read_value1 == test_val_addr1, \
            f"TIMING BUG DETECTED in TDPRAM Port B template:\n" \
            f"  Got: 0x{read_value1:X} (appears to be from address 1 or 2)\n" \
            f"  Expected: 0x{test_val_addr1:X} (from address 1, which was latched)\n"

        dut.ce_b.value = 0
