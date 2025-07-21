import random
from decimal import Decimal

import siliconcompiler

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, Combine
from cocotb.regression import TestFactory
from cocotb import utils

from lambdalib import ramlib
from lambdalib.utils._tb_common import (
    run_cocotb,
    drive_reset,
    random_bool_generator
)


@cocotb.test()
async def tdpram_rd_wr_test(
    dut,
    clk_a_period_ns=10.0,
    clk_b_period_ns=10.0
):

    await cocotb.start(Clock(dut.clk_a, clk_a_period_ns, units="ns").start())
    # Randomize phase shift between clocks
    await Timer(clk_a_period_ns * random.random(), "ns", round_mode="round")
    await cocotb.start(Clock(dut.clk_b, clk_b_period_ns, units="ns").start())

    # Initialze inputs
    dut.addr_a = 0
    dut.addr_b = 0
    dut.wmask_a = 0xffffffff
    dut.wmask_b = 0xffffffff
    dut.we_a.value = 0
    dut.we_b.value = 0
    dut.ce_a.value = 0
    dut.ce_b.value = 0
    
    await ClockCycles(dut.clk_a, 3)

    expected = 0x55555555
    # Do a write
    dut.we_a.value = 1
    dut.ce_a.value = 1
    # re_a.value = 0
    dut.din_a.value = 0x55555555
    await ClockCycles(dut.clk_a, 1)
    
    # Do a read
    dut.we_a.value = 0
    dut.ce_a.value = 1
    # dut.re_a.value = 1
    dut.din_a.value = 0x0
    await ClockCycles(dut.clk_a, 1)    
    await ClockCycles(dut.clk_a, 1)    
    actual = dut.dout_a.value

    assert actual == expected, f'Expected {expected} got {actual}'


def test_la_tdpram():
    chip = siliconcompiler.Chip("la_tdpram")

    chip.input("ramlib/rtl/la_tdpram.v", package='lambdalib')
    chip.use(ramlib)

    test_module_name = "lambdalib.ramlib.tests.tb_la_tdpram"
    test_name = f"{test_module_name}"
    tests_failed = run_cocotb(
        chip=chip,
        test_module_name=test_module_name,
        timescale=("1ns", "1ps"),
        parameters={
            "AW": 13,
            "DW": 32,
        },
        output_dir_name=test_name
    )
    assert (tests_failed == 0), f"Error test {test_name} failed!"


if __name__ == "__main__":
    test_la_tdpram()
