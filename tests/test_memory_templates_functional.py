"""
Functional tests for memory templates using cocotb simulation.

Uses SiliconCompiler Design framework to set up cocotb testbenches for
memory wrapper templates, following the pattern from test_la_asyncfifo.py
"""

import pytest

from pathlib import Path
from siliconcompiler import Design, Sim
from lambdalib.reusable_tests.cocotb_common import use_cocotb, SimCmdFiles
from lambdalib.ramlib._common import RAMLib
from lambdalib.ramlib import Spram


def create_mock_ram_class(name, width, depth, ports):
    """Factory function to create mock RAM classes for write_lambdalib"""
    class _MockRAM:
        def __init__(self):
            self.name = name
            self.width = width
            self.depth = depth
            self.ports = {port: wire for port, wire in ports}

        def get_ram_libcell(self):
            return self.name

        def get_ram_width(self):
            return self.width

        def get_ram_depth(self):
            return self.depth

        def get_ram_ports(self):
            return self.ports

    return _MockRAM


@pytest.mark.eda
@pytest.mark.timeout(300)
@pytest.mark.parametrize("macroaw, macrodw", [
    (7, 8),     # 128 x 8
    (8, 32),    # 256 x 32
    (9, 64),    # 512 x 64
])
@pytest.mark.parametrize("aw, dw", [
    (7, 32),    # 128 x 32
    (8, 8),     # 256 x 8
    (9, 16),    # 512 x 16
    (10, 64),   # 1024 x 64
])
def test_spram_cocotb_functional(macroaw, macrodw, aw, dw):
    """
    Run SPRAM cocotb functional tests with generated template.

    Tests the dynamically generated la_spram wrapper with various
    address and data widths, verifying write/read operations and
    write masking.
    """

    class SpramTbDesign(Design):
        """Testbench design for SPRAM cocotb functional tests"""

        def __init__(self, simulator: str = "icarus", wrapper_file = None, macro_file = None):
            super().__init__("testbench")
            self.set_dataroot("testdata", __file__)

            with self.active_dataroot("testdata"):
                with self.active_fileset("testbench.cocotb"):
                    self.set_topmodule("la_spram")
                    self.set_param("AW", str(aw))
                    self.set_param("DW", str(dw))
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")
                    # Add cocotb test procedures
                    self.add_file(Path(__file__).parent / "cocotb" / "test_spram.py", filetype="python")
                    # Add generated wrapper and testbench
                    self.add_file(str(wrapper_file), filetype="verilog")
                    self.add_file(str(macro_file), filetype="verilog")
                    self.add_depfileset(Spram(), "rtl.impl")

    # Generate SPRAM template and testbench, keeping files alive
    spram_lib = RAMLib("la_spram", ".")

    # Create mock RAM with specified AW and DW
    port_map = [
        ("clk", "clk"),
        ("mem_addr", "mem_addr"),
        ("ce_in", "ce_in"),
        ("mem_dout", "mem_dout"),
        ("we_in", "we_in"),
        ("mem_wmask", "mem_wmask"),
        ("mem_din", "mem_din")
    ]

    memories = [
        create_mock_ram_class("spram", macrodw, macroaw, port_map)
    ]

    wrapper_file = Path("la_spram.v")
    spram_lib.write_lambdalib(wrapper_file, memories)

    # Generate testbench that instantiates the wrapper
    macro_file = Path("spram_macro.v")
    macro_content = f'''
module spram(
    input clk,
    input [{macroaw-1}:0] mem_addr,
    input [{macrodw-1}:0] mem_din,
    input ce_in,
    input we_in,
    input [{macrodw-1}:0] mem_wmask,
    output [{macrodw-1}:0] mem_dout
);
    la_spram_impl memory (
        .clk(clk),
        .ce(ce_in),
        .we(we_in),
        .wmask(mem_wmask),
        .addr(mem_addr),
        .din(mem_din),
        .dout(mem_dout)
    );
endmodule
'''
    macro_file.write_text(macro_content)

    # Run cocotb simulation via SiliconCompiler
    project = Sim(SpramTbDesign("icarus", wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve()))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=False)
    project.set_flow("dvflow-icarus-cocotb")
    assert project.run()
