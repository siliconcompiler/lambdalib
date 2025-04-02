import siliconcompiler

from lambdalib import ramlib
import lambdalib.ramlib.tests.common as common


def test_la_asyncfifo():
    # Note: Clink phy should also work at an IOW of 128, 256, 512, and 1024
    # however those are omitted due to long test runtime
    chip = siliconcompiler.Chip("la_asyncfifo")

    chip.input("rtl/la_asyncfifo.v")
    chip.use(ramlib)

    for depth in [2, 4, 8]:
        test_module_name = "lambdalib.ramlib.tests.tb_la_asyncfifo"
        test_name = f"{test_module_name}_depth_{depth}"
        tests_failed = common.run_cocotb(
            chip=chip,
            test_module_name=test_module_name,
            timescale=("1ns", "1ps"),
            parameters={
                "DW": 32,
                "DEPTH": depth
            },
            output_dir_name=test_name
        )
        assert (tests_failed == 0), f"Error test {test_name} failed!"


if __name__ == "__main__":
    test_la_asyncfifo()
