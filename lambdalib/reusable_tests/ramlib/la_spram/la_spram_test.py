"""Cocotb tests for the la_spram (single-port RAM) module.

Contains two test strategies:
- **test_la_spram_fuzz**: Randomized input fuzzing with a passive RamMonitor
  that accumulates expected state, followed by readback verification.
- **test_la_spram_basic**: Directed random read/write sequences with an active
  RamDriver and software shadow memory for per-address verification.

Also provides TbDesign and run_test() for SiliconCompiler-based simulation flow.
"""

try:
    import cocotb
    import os

    from cocotb.triggers import Timer, FallingEdge
    from cocotb.clock import Clock
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    from lambdalib.reusable_tests.ramlib.common.spram_monitor import RamMonitor
    from lambdalib.reusable_tests.ramlib.common.spram_driver import RamDriver

    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from typing import List
from pathlib import Path
import random
from siliconcompiler import Design, Sim
from lambdalib.ramlib import Spram


if _has_cocotb:

    @cocotb.test()
    async def test_la_spram_fuzz(dut):
        """Test basic read/write operations of single-port RAM"""
        DW = int(dut.DW.value)
        AW = int(dut.AW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10
        n_trials = 10000
        # Use a timer period so that, starting from the falling edge
        # fuzz events never coincide with rising edges.
        # avoiding delta-cycle races with the monitor.
        time_per_trial = clk_period_ns // 5
        time_unit_per_trial = "ns"

        dut.ctrl.value = CTRL_VALUE

        ram_mon = RamMonitor(dut)

        # Start clock using cocotb Clock
        cocotb.start_soon(Clock(dut.clk, clk_period_ns, unit="ns").start())
        await FallingEdge(dut.clk)

        # Start monitor
        ram_mon.start()

        # Fuzz the dut
        for _ in range(n_trials):
            dut.ce.value = random.choices([0, 1], weights=[0.1, 0.9])[0]
            dut.we.value = random.choice([0, 1])
            dut.wmask.value = random.randint(0, (1 << DW) - 1)
            dut.addr.value = random.randint(0, (1 << AW) - 1)
            dut.din.value = random.randint(0, (1 << DW) - 1)
            await Timer(time_per_trial, unit=time_unit_per_trial)

        # Create driver to read RAM addresses
        ram = RamDriver(
            clk=dut.clk,
            ce=dut.ce,
            we=dut.we,
            wmask=dut.wmask,
            addr=dut.addr,
            din=dut.din,
            dout=dut.dout,
            ctrl=dut.ctrl
        )

        # Verify all written addresses can be read back correctly
        for address, expected in ram_mon.mem.items():
            actual = await ram.read(address, True, resolve="zeros")
            assert actual == expected

    @cocotb.test()
    async def test_la_spram_basic(dut):
        """Test basic read/write operations of single-port RAM"""
        DW = int(dut.DW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10
        n_trials = 100

        ram = RamDriver(
            clk=dut.clk,
            ce=dut.ce,
            we=dut.we,
            wmask=dut.wmask,
            addr=dut.addr,
            din=dut.din,
            dout=dut.dout,
            ctrl=dut.ctrl
        )

        # Initialize
        ram.init(ctrl_value=CTRL_VALUE)

        # Start clock using cocotb Clock
        cocotb.start_soon(Clock(ram.clk, clk_period_ns, unit="ns").start())
        await FallingEdge(ram.clk)

        def rand_address():
            rand_addresses = [
                0,
                (1 << ram.addr_width) - 1,
                random.randint(1, (1 << ram.addr_width)-2)
            ]
            # Use weighted random selection to increase likelihood of hitting edge cases
            address_weights = [0.10, 0.10, 0.80]
            return random.choices(rand_addresses, weights=address_weights)[0]

        # Dictionary to keep track of expected memory contents (accumulated)
        # Each entry is (accumulated_data, accumulated_wmask)
        mem = {}

        for _ in range(n_trials):
            wr = random.choice([True, False]) if mem else True
            if wr:
                address = rand_address()
                data = random.randint(0, (1 << DW) - 1)
                wmask = random.randint(0, (1 << DW) - 1)
                await ram.write(address, data, wmask, True)
                old_data, old_mask = mem.get(address, (0, 0))
                mem[address] = ((old_data & ~wmask) | (data & wmask), old_mask | wmask)
            else:
                address, (expected, mask) = random.choice(list(mem.items()))
                actual = await ram.read(address, True)
                assert (actual & mask) == (expected & mask)

        # Verify all written addresses can be read back correctly
        for address, (expected, mask) in mem.items():
            actual = await ram.read(address, True)
            assert (actual & mask) == (expected & mask)

else:
    def test_la_spram_fuzz():
        """Placeholder test when cocotb is not installed."""
        pass

    def test_la_spram_basic():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):
    """SiliconCompiler Design wrapper for la_spram cocotb testbench."""

    def __init__(
        self,
        dw: int,
        aw: int,
        simulator: str = "icarus",
        ctrl: int = 0,
        name: str = None,
        other_tests: List[Design] = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_{Path(__file__).stem}_dw{dw}_aw{aw}_ctrl{ctrl}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_spram")
                self.add_depfileset(Spram(), "rtl")
                self.set_param("DW", str(dw))
                self.set_param("AW", str(aw))

                if simulator in ["icarus", "verilator"]:
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file(Path(__file__).name, filetype="python")

                if other_tests is not None:
                    for test in other_tests:
                        self.add_depfileset(test, "testbench.cocotb")


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
