import random
from decimal import Decimal

import siliconcompiler

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, Combine, FallingEdge
from cocotb.regression import TestFactory
from cocotb import utils

from lambdalib import ramlib
from lambdalib.utils._tb_common import (
    run_cocotb,
    drive_reset,
    random_bool_generator
)

async def write_memory_port(dut, address, data, port):
    if (port == 'a'):
        await memory_write(dut.clk_a, dut.we_a, dut.ce_a, dut.addr_a, address, dut.din_a, data)
    elif (port == 'b'):
        await memory_write(dut.clk_b, dut.we_b, dut.ce_b, dut.addr_b, address, dut.din_b, data)
    else:
        raise ValueError("Port must be either \'a\' or \'b\'")


async def read_memory_port(dut, address, port):
    if (port == 'a'):
        return await memory_read(dut.clk_a, dut.we_a, dut.ce_a, dut.addr_a, address, dut.din_a)
    elif (port == 'b'):
        return await memory_read(dut.clk_b, dut.we_b, dut.ce_b, dut.addr_b, address, dut.din_b)
    else:
        raise ValueError("Port must be either \'a\' or \'b\'")


async def memory_write(
        clock,
        write_enable,
        clock_enable,
        address_bus,
        address_value,
        data_bus,
        data_value
):

    # Do a write
    write_enable.value = 1
    clock_enable.value = 1
    # re_a.value = 0
    address_bus.value = address_value
    data_bus.value = data_value
    # @(posedge clk);
    await FallingEdge(clock)
    

async def memory_read(
        clock,
        write_enable,
        clock_enable,
        address_bus,
        address_value,
        data_bus
):

    # Do a read
    write_enable.value = 0
    clock_enable.value = 1
    # re_a.value = 0
    address_bus.value = address_value    
    await FallingEdge(clock)
    return data_bus.value


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
    dut.addr_a.value = 0
    dut.addr_b.value = 0
    dut.wmask_a.value = 0xffffffff
    dut.wmask_b.value = 0xffffffff
    dut.we_a.value = 0
    dut.we_b.value = 0
    dut.ce_a.value = 0
    dut.ce_b.value = 0
    dut.din_a.value = 0x0
    dut.din_b.value = 0x0
    
    await FallingEdge(dut.clk_a)

    await write_memory_port(dut, 0x0, 0x55555555, 'a')
    actual = await read_memory_port(dut, 0x0, 'a')

    # Wait one more clock cycle to help out people looking at waveforms
    expected = 0x55555555
    await FallingEdge(dut.clk_a)
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
