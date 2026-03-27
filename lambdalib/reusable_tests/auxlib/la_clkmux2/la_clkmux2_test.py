try:
    import cocotb
    from cocotb.clock import Clock

    from cocotb.triggers import Timer
    from lambdalib.reusable_tests.cocotb_common import SimCmdFiles, use_cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False

import string
import random
from decimal import Decimal
from pathlib import Path
from itertools import product

from siliconcompiler import Design, Sim
from lambdalib.auxlib import Clkmux2


if _has_cocotb:

    async def monitor_clk_out_period(clk_out, minimum_time_between_edges):
        last_time = None
        margin_ns = 0.1
        while True:
            await clk_out.value_change
            cur_time = cocotb.simtime.get_sim_time(unit="ns")
            if last_time is not None:
                time = cur_time - last_time
                if float(time + margin_ns) < float(minimum_time_between_edges):
                    await Timer(1, unit="ns")
                    assert float(time + margin_ns) >= float(minimum_time_between_edges), \
                        f"clk_out transition between edges too short: {time} ns"

            last_time = cur_time

    def random_decimal(max: int, min: int, decimal_places=2) -> Decimal:
        prefix = str(random.randint(min, max))
        suffix = ''.join(random.choice(string.digits) for _ in range(decimal_places))
        return Decimal(prefix + "." + suffix)

    @cocotb.test()
    async def test_la_clkmux2_fuzz(dut):
        fuzz_time_step_max_ns = 1
        fuzz_time_step_max_ns = 2

        fuzz_trials = 10000

        max_clk_period_ns = 13
        min_clk_period_ns = 1

        # Generate random clk periods to test between min and max
        clk_periods_ns = [
            min_clk_period_ns,
            max_clk_period_ns,
            random_decimal(max_clk_period_ns, min_clk_period_ns)
        ]

        clk_period_ns_groups = list(product(clk_periods_ns, repeat=2))

        dut.sel.value = 0

        for (clk_0_period_ns, clk_1_period_ns) in clk_period_ns_groups:

            dut.clk0.value = 0
            dut.clk1.value = 0

            # Reset DUT
            dut.nreset.value = 1
            await Timer(1, unit="step")
            dut.nreset.value = 0
            await Timer(1, unit="ns")
            dut.nreset.value = 1

            # Start clock out period monitor
            mon_period_task = cocotb.start_soon(monitor_clk_out_period(
                dut.out,
                minimum_time_between_edges=min(clk_0_period_ns, clk_1_period_ns) / 2
            ))

            for _ in range(5):
                # Start clocks
                clk_0_task = Clock(signal=dut.clk0, period=clk_0_period_ns, unit="ns").start()
                # Random phase shift
                await Timer(Decimal(random.random()) * clk_0_period_ns, unit="ns", round_mode="round")
                clk_1_task = Clock(signal=dut.clk1, period=clk_1_period_ns, unit="ns").start()

                # Fuzz DUT
                for _ in range(fuzz_trials):
                    if random.random() > 0.9:
                        dut.sel.value = random.choices([0, 1], weights=[0.5, 0.5])[0]

                    await Timer(fuzz_time_step_max_ns, unit="ns")

                clk_0_task.cancel()
                clk_1_task.cancel()
                await Timer(max(clk_0_period_ns, clk_1_period_ns), unit="ns")

            mon_period_task.cancel()
            await Timer(1, unit="us")


else:
    def test_la_clkmux2_fuzz():
        """Placeholder test when cocotb is not installed."""
        pass


class TbDesign(Design):

    def __init__(
        self,
        simulator: str = "icarus",
        name: str = None
    ):
        super().__init__()

        if name is None:
            name = f"cocotb_test_{Path(__file__).stem}_sim_{simulator}"

        # Set the design's name
        self.set_name(name)

        # Establish the root directory for all design-related files
        self.set_dataroot(name, __file__)

        with self.active_dataroot(name):
            with self.active_fileset("testbench.cocotb"):
                self.set_topmodule("la_clkmux2")
                self.add_depfileset(Clkmux2(), "rtl")

                self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")

                self.add_file(Path(__file__).name, filetype="python")


def run_test(
    simulator: str,
    output_wave: bool
):
    if not _has_cocotb:
        raise RuntimeError("Cocotb is not installed; cannot run test.")

    project = Sim(TbDesign(simulator))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=output_wave)
    project.set_flow(f"dvflow-{simulator}-cocotb")

    project.run()
    project.summary()
