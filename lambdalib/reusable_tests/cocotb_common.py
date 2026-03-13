import math
import random
import string
from decimal import Decimal

from cocotb.triggers import Timer
from cocotb.handle import SimHandleBase

from siliconcompiler import Design, Sim
from siliconcompiler.flows.dvflow import DVFlow

from siliconcompiler.tools.icarus.compile import CompileTask as IcarusCompileTask
from siliconcompiler.tools.icarus.cocotb_exec import CocotbExecTask as IcarusCocotbExecTask

from siliconcompiler.tools.verilator.cocotb_compile import CocotbCompileTask as VerilatorCompileTask
from siliconcompiler.tools.verilator.cocotb_exec import CocotbExecTask as VerilatorCocotbExecTask


async def do_reset(
        reset: SimHandleBase,
        time_ns: int,
        active_level: bool = False):
    """Perform a async reset"""
    reset.value = not active_level
    await Timer(1, unit="step")
    reset.value = active_level
    await Timer(time_ns, "ns")
    reset.value = not active_level
    await Timer(1, unit="step")


def random_decimal(max: int, min: int, decimal_places=2) -> Decimal:
    prefix = str(random.randint(min, max))
    suffix = ''.join(random.choice(string.digits) for _ in range(decimal_places))
    return Decimal(prefix + "." + suffix)


def random_toggle_generator(on_range=(0, 15), off_range=(0, 15)):
    return bit_toggler_generator(
        gen_on=(random.randint(*on_range) for _ in iter(int, 1)),
        gen_off=(random.randint(*off_range) for _ in iter(int, 1))
    )


def sine_wave_generator(amplitude, w, offset=0):
    while True:
        for idx in (i / float(w) for i in range(int(w))):
            yield amplitude * math.sin(2 * math.pi * idx) + offset


def bit_toggler_generator(gen_on, gen_off):
    for n_on, n_off in zip(gen_on, gen_off):
        yield int(abs(n_on)), int(abs(n_off))


def wave_generator(on_ampl=30, on_freq=200, off_ampl=10, off_freq=100):
    return bit_toggler_generator(sine_wave_generator(on_ampl, on_freq),
                                 sine_wave_generator(off_ampl, off_freq))


class IcarusDesign(Design):
    def __init__(self, design: Design):
        super().__init__()

        name = f"{design.name}_icarus_sim"

        self.set_dataroot("icarus_tb", __file__)

        with self.active_dataroot("icarus_tb"):
            with self.active_fileset("icarus_sim"):
                self.add_file("sim_cmd_files/icarus_cmd_file.f", filetype="commandfile")
                self.add_depfileset(design, "testbench.cocotb")
                self.set_topmodule(design.get_topmodule("testbench.cocotb"))
                name_suffix = ""
                for param in design.getkeys("fileset", "testbench.cocotb", "param"):
                    pval = design.get_param(param, "testbench.cocotb")
                    self.set_param(param, pval)
                    name_suffix += f"_{param}_{pval}"

        name += name_suffix
        self.set_name(name)


class VerilatorDesign(Design):
    def __init__(self, design: Design):
        super().__init__()

        name = f"{design.name}_verilator_sim"

        self.set_dataroot("verilator_tb", __file__)

        with self.active_dataroot("verilator_tb"):
            with self.active_fileset("verilator_sim"):
                self.add_file("sim_cmd_files/verilator_cmd_file.vc", filetype="commandfile")
                self.add_depfileset(design, "testbench.cocotb")
                self.set_topmodule(design.get_topmodule("testbench.cocotb"))
                name_suffix = ""
                for param in design.getkeys("fileset", "testbench.cocotb", "param"):
                    pval = design.get_param(param, "testbench.cocotb")
                    self.set_param(param, pval)
                    name_suffix += f"_{param}_{pval}"

        name += name_suffix
        self.set_name(name)


def load_cocotb_test(
    design: Design,
    simulator="icarus",
    trace=True,
    seed=None
):

    supported = ("icarus", "verilator")
    if simulator == "icarus":
        load_cocotb_icarus_sim(design, trace=trace, seed=seed)
    elif simulator == "verilator":
        load_cocotb_verilator_sim(design, trace=trace, seed=seed, trace_type="vcd")
    else:
        raise ValueError(
            f"Unsupported simulator '{simulator}'. Supported: {supported}"
        )


def load_cocotb_icarus_sim(
    design: Design,
    trace=True,
    seed=None
):
    project = Sim()
    project.set_design(IcarusDesign(design))
    project.add_fileset("icarus_sim")
    project.set_flow(DVFlow(tool="icarus-cocotb"))

    IcarusCompileTask.find_task(project).set_trace_enabled(trace)

    if seed is not None:
        IcarusCocotbExecTask.find_task(project).set_cocotb_randomseed(seed)

    project.run()
    project.summary()

    results = project.find_result(
        step='simulate',
        index='0',
        directory="outputs",
        filename="results.xml"
    )
    if results:
        print(f"\nCocotb results file: {results}")


def load_cocotb_verilator_sim(
    design: Design,
    trace=True,
    seed=None,
    trace_type="vcd"
):
    project = Sim()
    project.set_design(VerilatorDesign(design))
    project.add_fileset("verilator_sim")
    project.set_flow(DVFlow(tool="verilator-cocotb"))

    # Enable waveform tracing (must be enabled on both compile and simulate tasks)
    compile_task = VerilatorCompileTask.find_task(project)
    compile_task.set_verilator_trace(trace)
    compile_task.set_verilator_tracetype(trace_type)

    cocotb_task = VerilatorCocotbExecTask.find_task(project)
    cocotb_task.set_cocotb_trace(
        enable=trace,
        trace_type=trace_type
    )

    # Optionally set a random seed for reproducibility
    if seed is not None:
        cocotb_task.set_cocotb_randomseed(seed)

    # Run the simulation
    project.run()
    project.summary()

    # Find and display the results file
    results = project.find_result(
        step='simulate',
        index='0',
        directory="outputs",
        filename="results.xml"
    )
    if results:
        print(f"\nCocotb results file: {results}")
