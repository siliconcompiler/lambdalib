import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, Combine
from cocotb.regression import TestFactory
from cocotb import utils

from lambdalib.ramlib.tests.common import (
    drive_reset,
    random_bool_generator
)

from lambdalib.ramlib.tests.la_asyncfifo import (
    LaAsyncFifoWrBus,
    LaAsyncFifoRdBus,
    LaAsyncFifoSource,
    LaAsyncFifoSink
)


def bursty_en_gen(burst_len=20):
    while True:
        en_state = (random.randint(0, 1) == 1)
        for _ in range(0, burst_len):
            yield en_state


@cocotb.test()
async def test_almost_full(dut):

    wr_clk_period_ns = 10.0
    rd_clk_period_ns = 10.0

    fifo_source = LaAsyncFifoSource(
        bus=LaAsyncFifoWrBus.from_prefix(dut, ""),
        clock=dut.wr_clk,
        reset=dut.wr_nreset
    )

    fifo_sink = LaAsyncFifoSink(
        bus=LaAsyncFifoRdBus.from_prefix(dut, ""),
        clock=dut.rd_clk,
        reset=dut.rd_nreset
    )
    fifo_sink.pause()

    # Reset DUT
    await Combine(
        cocotb.start_soon(drive_reset(dut.wr_nreset)),
        cocotb.start_soon(drive_reset(dut.rd_nreset))
    )

    await cocotb.start(Clock(dut.wr_clk, wr_clk_period_ns, units="ns").start())
    # Randomize phase shift between clocks
    await Timer(wr_clk_period_ns * random.random(), "ns", round_mode="round")
    await cocotb.start(Clock(dut.rd_clk, rd_clk_period_ns, units="ns").start())

    almost_full_level = int(dut.ALMOST_FULL_LEVEL.value)

    await ClockCycles(dut.wr_clk, 3)

    # Almost full should be low before writing to FIFO
    assert dut.wr_almost_full.value == 0

    # Write to FIFO    
    for i in range(0, almost_full_level):
        await fifo_source.send(i)

    # Wait for write to complete
    await fifo_source.wait_until_idle()
    assert dut.wr_almost_full.value == 1

    # Read one value out of FIFO
    fifo_sink.resume()
    await fifo_sink.read()
    fifo_sink.pause()

    # Check that almost full is lowered
    await ClockCycles(dut.wr_clk, 4)
    assert dut.wr_almost_full.value == 0


async def fifo_rd_wr_test(
    dut,
    wr_clk_period_ns=10.0,
    rd_clk_period_ns=10.0,
    wr_en_generator=None,
    rd_en_generator=None
):

    fifo_source = LaAsyncFifoSource(
        bus=LaAsyncFifoWrBus.from_prefix(dut, ""),
        clock=dut.wr_clk,
        reset=dut.wr_nreset
    )
    fifo_source.set_wr_en_generator(random_bool_generator())

    fifo_sink = LaAsyncFifoSink(
        bus=LaAsyncFifoRdBus.from_prefix(dut, ""),
        clock=dut.rd_clk,
        reset=dut.rd_nreset
    )
    fifo_sink.set_rd_en_generator(random_bool_generator())

    # Reset DUT
    await Combine(
        cocotb.start_soon(drive_reset(dut.wr_nreset)),
        cocotb.start_soon(drive_reset(dut.rd_nreset))
    )

    await cocotb.start(Clock(dut.wr_clk, wr_clk_period_ns, units="ns").start())
    # Randomize phase shift between clocks
    await Timer(wr_clk_period_ns * random.random(), "ns", round_mode="round")
    await cocotb.start(Clock(dut.rd_clk, rd_clk_period_ns, units="ns").start())

    await ClockCycles(dut.wr_clk, 3)

    expected_len = 256
    expected = [random.getrandbits(len(dut.wr_din)) for _ in range(expected_len)]

    for val in expected:
        await fifo_source.send(val)

    actual = [await fifo_sink.read() for _ in range(expected_len)]

    assert actual == expected

    await ClockCycles(dut.wr_clk, 10)


# Generate sets of tests based on the different permutations of the possible arguments to fifo_test
MAX_PERIOD_NS = 10.0
MIN_PERIOD_NS = 1.0
# Generate random clk period to test between min and max
RAND_WR_CLK_PERIOD_NS, RAND_RD_CLK_PERIOD_NS = [utils.get_time_from_sim_steps(
    # Time step must be even for cocotb clock driver
    steps=utils.get_sim_steps(
        time=MIN_PERIOD_NS + ((MAX_PERIOD_NS - MIN_PERIOD_NS) * random.random()),
        units="ns",
        round_mode="round"
    ) & ~1,
    units="ns"
) for _ in range(0, 2)]

tf = TestFactory(fifo_rd_wr_test)
tf.add_option('wr_clk_period_ns', [MIN_PERIOD_NS, RAND_WR_CLK_PERIOD_NS, MAX_PERIOD_NS])
tf.add_option('rd_clk_period_ns', [MIN_PERIOD_NS, RAND_RD_CLK_PERIOD_NS, MAX_PERIOD_NS])
tf.add_option('wr_en_generator', [None, random_bool_generator, bursty_en_gen])
tf.add_option('rd_en_generator', [None, random_bool_generator, bursty_en_gen])
tf.generate_tests()
