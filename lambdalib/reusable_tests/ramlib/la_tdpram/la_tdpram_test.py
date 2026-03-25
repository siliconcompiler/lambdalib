try:
    import cocotb
    import os

    from cocotb.triggers import Timer, FallingEdge
    from cocotb.clock import Clock
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    from lambdalib.reusable_tests.ramlib.common.spram_driver import RamDriver
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

import random
from typing import List
from pathlib import Path
from siliconcompiler import Design, Sim
from lambdalib.ramlib import Tdpram


if _has_cocotb:

    @cocotb.test()
    async def test_la_tdpram_basic(dut):
        """Test basic read/write operations of true dual-port RAM"""
        DW = int(dut.DW.value)
        AW = int(dut.AW.value)
        CTRL_VALUE = int(os.environ.get('CTRL_VALUE', 0))
        clk_period_ns = 10

        port_a = RamDriver(
            clk=dut.clk_a,
            ce=dut.ce_a,
            we=dut.we_a,
            wmask=dut.wmask_a,
            addr=dut.addr_a,
            din=dut.din_a,
            dout=dut.dout_a,
            ctrl=dut.ctrl
        )

        port_b = RamDriver(
            clk=dut.clk_b,
            ce=dut.ce_b,
            we=dut.we_b,
            wmask=dut.wmask_b,
            addr=dut.addr_b,
            din=dut.din_b,
            dout=dut.dout_b,
            ctrl=dut.ctrl
        )

        port_a.init(CTRL_VALUE)
        port_b.init(CTRL_VALUE)

        # Start clocks using cocotb Clock
        cocotb.start_soon(Clock(dut.clk_a, clk_period_ns, unit="ns").start())
        cocotb.start_soon(Clock(dut.clk_b, clk_period_ns, unit="ns").start())

        def rand_address(min_addr: int, max_addr: int):
            rand_addresses = [
                min_addr,
                max_addr,
                random.randint(min_addr + 1, max_addr - 1)
            ]
            # Use weighted random selection to increase likelihood of hitting edge cases
            address_weights = [0.10, 0.10, 0.80]
            return random.choices(rand_addresses, weights=address_weights)[0]

        async def rw_test(ram_driver: RamDriver, n_cycles: int, addresses: List[int]):
            await FallingEdge(ram_driver.clk)
            mem = {}
            for _ in range(n_cycles):
                wr = random.choice([True, False]) if mem else True
                if wr:
                    address = random.choice(addresses)
                    data = random.randint(0, (1 << DW) - 1)
                    wmask = random.randint(0, (1 << DW) - 1)
                    await ram_driver.write(address, data, wmask, True)
                    mem[address] = (wmask, data)
                else:
                    address, (wmask, expected) = random.choice(list(mem.items()))
                    actual = await ram_driver.read(address, True)
                    assert (actual & wmask) == (expected & wmask)
            return mem

        # Generate a set of unique random addresses to test
        n_possible_addresses = min((1 << AW) - 1, 1000)
        addresses = random.sample(range(0, 1 << AW), n_possible_addresses)

        # Create two seperate unique lists of addresses
        addr_space_0 = addresses[:len(addresses) // 2]
        addr_space_1 = addresses[len(addresses) // 2:]

        for as0, as1 in [(addr_space_0, addr_space_1), (addr_space_1, addr_space_0)]:
            port_a_rw_test_task = cocotb.start_soon(
                rw_test(port_a, 100, as0)
            )

            port_b_rw_test_task = cocotb.start_soon(
                rw_test(port_b, 100, as1)
            )

            for driver, task in [(port_a, port_a_rw_test_task), (port_b, port_b_rw_test_task)]:
                mem = await task

                # Verify all written addresses can be read back correctly
                for address, (wmask, expected) in mem.items():
                    actual = await driver.read(address, True)
                    assert (actual & wmask) == (expected & wmask)


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
                self.set_topmodule("la_tdpram")
                self.add_depfileset(Tdpram(), "rtl")
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
