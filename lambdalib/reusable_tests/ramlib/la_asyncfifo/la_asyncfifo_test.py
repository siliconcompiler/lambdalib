import random
from decimal import Decimal

try:
    import cocotb
    from cocotb.clock import Clock
    from cocotb.triggers import ClockCycles, Timer, Combine

    from cocotb_bus.scoreboard import Scoreboard
    from cocotb_bus.drivers import BitDriver

    from lambdalib.reusable_tests.ramlib.la_asyncfifo.la_asyncfifo_wr_driver import (
        LaAsyncFifoWrDriver
    )
    from lambdalib.reusable_tests.ramlib.la_asyncfifo.la_asyncfifo_rd_monitor import (
        LaAsyncFifoRdMonitor
    )

    from lambdalib.reusable_tests.cocotb_common import (
        use_cocotb,
        SimCmdFiles,
        do_reset,
        random_decimal,
        random_toggle_generator,
        wave_generator
    )

    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

from siliconcompiler import Design, Sim
from lambdalib.ramlib import Asyncfifo


if _has_cocotb:

    @cocotb.test()
    async def test_almost_full(dut):

        wr_clk_period_ns = 10
        rd_clk_period_ns = 10

        ####################################
        # Create BFMs
        ####################################
        fifo_source = LaAsyncFifoWrDriver(
            entity=dut,
            name="",
            clock=dut.wr_clk
        )

        fifo_sink = LaAsyncFifoRdMonitor(
            entity=dut,
            name="",
            clock=dut.rd_clk,
            reset_n=dut.rd_nreset
        )

        dut.rd_en.value = 0

        ####################################
        # Handle clocking / resets
        ####################################

        # Reset DUT
        await Combine(
            cocotb.start_soon(do_reset(dut.wr_nreset, time_ns=wr_clk_period_ns*5)),
            cocotb.start_soon(do_reset(dut.rd_nreset, time_ns=rd_clk_period_ns*5))
        )

        Clock(dut.wr_clk, wr_clk_period_ns, unit="ns").start()
        dut.selctrl.value = 0

        # Randomize phase shift between clocks
        await Timer(wr_clk_period_ns * Decimal(random.random()), "ns", round_mode="round")

        Clock(dut.rd_clk, rd_clk_period_ns, unit="ns").start()

        almost_full_level = int(dut.AFULLFINAL.value)

        await ClockCycles(dut.wr_clk, 3)

        ####################################
        # Test DUT
        ####################################

        if (int(dut.DEPTH.value) != 1):
            # Almost full should be low before writing to FIFO
            assert bool(dut.wr_almost_full.value) is False

            # Write to FIFO
            for i in range(0, almost_full_level):
                await fifo_source.send(i)

            await ClockCycles(dut.wr_clk, 1)

            assert bool(dut.wr_almost_full.value) is True

            # Read one value out of FIFO
            dut.rd_en.value = 1
            await fifo_sink.wait_for_recv()
            dut.rd_en.value = 0

            # Check that almost full is lowered
            await ClockCycles(dut.wr_clk, 4)
            assert bool(dut.wr_almost_full.value) is False
        else:
            # Special case when DEPTH == 1 FIFO is always almost full
            assert bool(dut.wr_almost_full.value) is True
            await fifo_source.send(0)
            await ClockCycles(dut.wr_clk, 1)
            assert bool(dut.wr_almost_full.value) is True

    # Generate sets of tests based on the different
    # permutations of the possible arguments to fifo_test
    MAX_PERIOD_NS = 10
    MIN_PERIOD_NS = 1
    # Generate random clk periods to test between min and max
    RAND_WR_CLK_PERIOD_NS = random_decimal(MAX_PERIOD_NS, MIN_PERIOD_NS)
    RAND_RD_CLK_PERIOD_NS = random_decimal(MAX_PERIOD_NS, MIN_PERIOD_NS)

    @cocotb.test()
    @cocotb.parametrize(
        wr_clk_period_ns=[MIN_PERIOD_NS, RAND_WR_CLK_PERIOD_NS, MAX_PERIOD_NS],
        rd_clk_period_ns=[MIN_PERIOD_NS, RAND_RD_CLK_PERIOD_NS, MAX_PERIOD_NS],
        wr_en_factory=[None, random_toggle_generator, wave_generator],
        rd_en_factory=[None, random_toggle_generator, wave_generator]
    )
    async def fifo_rd_wr_test(
        dut,
        wr_clk_period_ns=10,
        rd_clk_period_ns=10,
        wr_en_factory=None,
        rd_en_factory=None,
        test_n_trans=256
    ):
        # Create fresh generators per test to avoid exhaustion across permutations
        wr_en_generator = None
        if wr_en_factory:
            wr_en_generator = wr_en_factory()

        rd_en_generator = None
        if rd_en_factory:
            rd_en_generator = rd_en_factory()

        ####################################
        # Create BFMs
        ####################################
        fifo_source = LaAsyncFifoWrDriver(
            entity=dut,
            name="",
            clock=dut.wr_clk,
            valid_generator=wr_en_generator
        )

        fifo_sink = LaAsyncFifoRdMonitor(
            entity=dut,
            name="",
            clock=dut.rd_clk,
            reset_n=dut.rd_nreset
        )

        # Assign constant or bit driver to rd_en signal
        if rd_en_generator is None:
            dut.rd_en.value = 1
        else:
            BitDriver(signal=dut.rd_en, clk=dut.rd_clk).start(generator=rd_en_generator)

        expected_output = [random.getrandbits(len(dut.wr_din)) for _ in range(test_n_trans)]
        scoreboard = Scoreboard(dut, fail_immediately=True)
        scoreboard.add_interface(monitor=fifo_sink, expected_output=expected_output)

        ####################################
        # Handle clocking / resets
        ####################################

        # Reset DUT
        await Combine(
            cocotb.start_soon(do_reset(dut.wr_nreset, time_ns=wr_clk_period_ns*5)),
            cocotb.start_soon(do_reset(dut.rd_nreset, time_ns=rd_clk_period_ns*5))
        )

        Clock(dut.wr_clk, wr_clk_period_ns, unit="ns").start()
        dut.selctrl.value = 0

        # Randomize phase shift between clocks
        await Timer(wr_clk_period_ns * Decimal(random.random()), "ns", round_mode="round")

        Clock(dut.rd_clk, rd_clk_period_ns, unit="ns").start()

        await ClockCycles(dut.wr_clk, 3)

        ####################################
        # Test DUT
        ####################################

        # Drive test data into DUT
        for trans in expected_output:
            fifo_source.append(trans)

        # Wait for scoreboard to consume all expected outputs
        while len(expected_output) != 0:
            await ClockCycles(dut.rd_clk, 1)

        await ClockCycles(dut.rd_clk, 10)

        # Verify scoreboard results
        raise scoreboard.result

else:
    def test_almost_full():
        """Placeholder test when cocotb is not installed."""
        pass

    def fifo_rd_wr_test():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):

    def __init__(
        self,
        depth: int,
        simulator: str = "icarus",
        name: str = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_test_la_asyncfifo_depth_{depth}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_asyncfifo")
                self.add_depfileset(Asyncfifo(), "rtl")
                self.set_param("DEPTH", str(depth))

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file("la_asyncfifo_test.py", filetype="python")
                self.add_file("la_asyncfifo_wr_driver.py", filetype="python")
                self.add_file("la_asyncfifo_rd_monitor.py", filetype="python")


def run_test(
    depth: int,
    simulator: str,
    output_wave: bool
):
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    project = Sim(TbDesign(depth, simulator))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=output_wave)
    project.set_flow(f"dvflow-{simulator}-cocotb")

    project.run()
    project.summary()
