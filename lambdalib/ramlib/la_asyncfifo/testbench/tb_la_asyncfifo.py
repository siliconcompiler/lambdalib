import random
import string
from decimal import Decimal

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, Combine

from lambdalib.utils._tb_common import (
    run_cocotb,
    do_reset,
    random_bool_generator
)
from .la_asyncfifo import (
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


def random_decimal(max: int, min: int, decimal_places=2) -> Decimal:
    prefix = str(random.randint(min, max))
    suffix = ''.join(random.choice(string.digits) for _ in range(decimal_places))
    return Decimal(prefix + "." + suffix)


@cocotb.test(timeout_time=100, timeout_unit="ms")
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
        cocotb.start_soon(do_reset(dut.wr_nreset, time_ns=wr_clk_period_ns*4)),
        cocotb.start_soon(do_reset(dut.rd_nreset, time_ns=rd_clk_period_ns*4))
    )

    Clock(dut.wr_clk, wr_clk_period_ns, units="ns").start()
    # Randomize phase shift between clocks
    await Timer(wr_clk_period_ns * random.random(), "ns", round_mode="round")
    Clock(dut.rd_clk, rd_clk_period_ns, units="ns").start()

    almost_full_level = int(dut.AFULLFINAL.value)

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


# Generate sets of tests based on the different permutations of the possible arguments to fifo_test
MAX_PERIOD_NS = 10
MIN_PERIOD_NS = 1
# Generate random clk period to test between min and max
RAND_WR_CLK_PERIOD_NS, RAND_RD_CLK_PERIOD_NS = [
    random_decimal(MAX_PERIOD_NS, MIN_PERIOD_NS) for _ in range(2)
]


@cocotb.test(timeout_time=100, timeout_unit="ms")
@cocotb.parametrize(
    wr_clk_period_ns=[MIN_PERIOD_NS, RAND_WR_CLK_PERIOD_NS, MAX_PERIOD_NS],
    rd_clk_period_ns=[MIN_PERIOD_NS, RAND_RD_CLK_PERIOD_NS, MAX_PERIOD_NS],
    wr_en_generator=[None, random_bool_generator, bursty_en_gen],
    rd_en_generator=[None, random_bool_generator, bursty_en_gen]
)
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
    if wr_en_generator:
        fifo_source.set_wr_en_generator(wr_en_generator())

    fifo_sink = LaAsyncFifoSink(
        bus=LaAsyncFifoRdBus.from_prefix(dut, ""),
        clock=dut.rd_clk,
        reset=dut.rd_nreset
    )
    if rd_en_generator:
        fifo_sink.set_rd_en_generator(rd_en_generator())

    # Reset DUT
    await Combine(
        cocotb.start_soon(do_reset(dut.wr_nreset, time_ns=wr_clk_period_ns*4)),
        cocotb.start_soon(do_reset(dut.rd_nreset, time_ns=rd_clk_period_ns*4))
    )

    Clock(dut.wr_clk, wr_clk_period_ns, units="ns").start()
    # Randomize phase shift between clocks
    await Timer(wr_clk_period_ns * Decimal(random.random()), "ns", round_mode="round")
    Clock(dut.rd_clk, rd_clk_period_ns, units="ns").start()

    await ClockCycles(dut.wr_clk, 3)

    expected_len = 256
    expected = [random.getrandbits(len(dut.wr_din)) for _ in range(expected_len)]

    for val in expected:
        await fifo_source.send(val)

    actual = [await fifo_sink.read() for _ in range(expected_len)]

    assert actual == expected

    await ClockCycles(dut.wr_clk, 10)


def load_cocotb_test():
    from siliconcompiler import Sim
    from lambdalib.ramlib import Asyncfifo

    project = Sim(Asyncfifo())
    project.add_fileset("rtl")

    for depth in [2, 4, 8]:
        test_module_name = __name__
        test_name = f"{test_module_name}_depth_{depth}"
        tests_failed = run_cocotb(
            project=project,
            test_module_name=test_module_name,
            timescale=("1ns", "1ps"),
            parameters={
                "DW": 32,
                "DEPTH": depth
            },
            output_dir_name=test_name,
            waves=False
        )
        assert (tests_failed == 0), f"Error test {test_name} failed!"
