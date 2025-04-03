import random

import siliconcompiler

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

from lambdalib import auxlib
from lambdalib.utils._tb_common import run_cocotb


@cocotb.test()
async def ddr_sim_bug(dut):

    dut.d_in.value = 0

    await cocotb.start(Clock(dut.clk, 10, units="ns").start())
    await ClockCycles(dut.clk, 10)

    async def wait_one_clk_and_sample(signal, clk):
        val = int(signal.value)
        await ClockCycles(clk, 1)
        return val

    for i in range(0, 10):
        expected = random.choice([0x2, 0x1])
        # Drive expected value into ODDR for 1 cycle
        dut.d_in.value = expected
        await ClockCycles(dut.clk, 1)
        dut.d_in.value = 0
        # Wait for expected value to appear at the output of IDDR some cycles later
        values = [await wait_one_clk_and_sample(dut.d_out, dut.clk) for _ in range(0, 4)]
        assert expected in values
        await ClockCycles(dut.clk, 5)


def test_ddr_sim_bug():
    chip = siliconcompiler.Chip("ddr_simulation_bug")

    chip.input("../testbench/ddr_simulation_bug.v")
    chip.use(auxlib)

    test_module_name = "lambdalib.auxlib.tests.tb_ddr_simulation_bug"
    test_name = f"{test_module_name}"
    tests_failed = run_cocotb(
        chip=chip,
        test_module_name=test_module_name,
        timescale=("1ns", "1ps"),
        output_dir_name=test_name
    )
    assert (tests_failed == 0), f"Error test {test_name} failed!"


if __name__ == "__main__":
    test_ddr_sim_bug()
