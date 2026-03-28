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
from lambdalib.ramlib import Spram, Spregfile, Dpram, Tdpram


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

        def get_ram_defaultctrl(self) -> str:
            """Returns the default control signal value for the RAM cell."""
            # Detect if dual-port or single-port by checking port names
            port_names = [port for port, _ in ports]
            is_dual_port = any('wr_' in p or 'rd_' in p for p in port_names)
            is_true_dual_port = any('_a' in p or '_b' in p for p in port_names)

            if is_true_dual_port:
                # True dual port with independently accessed ports
                return "16'b1_1_0_10_101_1_0_10_100"
            elif is_dual_port:
                # Dual port with separate read/write clocks
                return "14'b1_1_0_10_100_1_10_100"
            else:
                # Single port
                return "8'b1_0_1_10_101"

        def get_ram_defaultctrl_width(self) -> int:
            """Returns the width of the default control signal for the RAM cell."""
            # Detect if dual-port or single-port by checking port names
            port_names = [port for port, _ in ports]
            is_dual_port = any('wr_' in p or 'rd_' in p for p in port_names)
            is_true_dual_port = any('_a' in p or '_b' in p for p in port_names)

            if is_true_dual_port:
                return 16
            elif is_dual_port:
                return 14
            else:
                return 8

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
    pytest.importorskip("cocotb")

    class SpramTbDesign(Design):
        """Testbench design for SPRAM cocotb functional tests"""

        def __init__(self, simulator: str = "icarus", wrapper_file=None, macro_file=None):
            super().__init__("testbench")
            self.set_dataroot("testdata", __file__)

            with self.active_dataroot("testdata"):
                with self.active_fileset("testbench.cocotb"):
                    self.set_topmodule("la_spram")
                    self.set_param("AW", str(aw))
                    self.set_param("DW", str(dw))
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")
                    # Add cocotb test procedures
                    self.add_file(Path(__file__).parent / "cocotb_tests" / "test_spram.py",
                                  filetype="python")
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
    la_spram_impl #(
        .AW({macroaw}),
        .DW({macrodw})
    ) memory (
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
    project = Sim(SpramTbDesign("icarus",
                                wrapper_file=wrapper_file.resolve(),
                                macro_file=macro_file.resolve()))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=False)
    project.set_flow("dvflow-icarus-cocotb")
    project.option.set_env("COCOTB_MACROAW", str(macroaw))
    assert project.run()


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
def test_spregfile_cocotb_functional(macroaw, macrodw, aw, dw):
    """
    Run SPREGFILE cocotb functional tests with generated template.

    Tests the dynamically generated la_spregfile wrapper with various
    address and data widths, verifying write/read operations and
    write masking.
    """
    pytest.importorskip("cocotb")

    class SpregfileTbDesign(Design):
        """Testbench design for SPREGFILE cocotb functional tests"""

        def __init__(self, simulator: str = "icarus", wrapper_file=None, macro_file=None):
            super().__init__("testbench")
            self.set_dataroot("testdata", __file__)

            with self.active_dataroot("testdata"):
                with self.active_fileset("testbench.cocotb"):
                    self.set_topmodule("la_spregfile")
                    self.set_param("AW", str(aw))
                    self.set_param("DW", str(dw))
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")
                    # Add cocotb test procedures
                    self.add_file(Path(__file__).parent / "cocotb_tests" / "test_spregfile.py",
                                  filetype="python")
                    # Add generated wrapper and macro
                    self.add_file(str(wrapper_file), filetype="verilog")
                    self.add_file(str(macro_file), filetype="verilog")
                    self.add_depfileset(Spregfile(), "rtl.impl")

    # Generate SPREGFILE template via write_lambdalib
    spregfile_lib = RAMLib("la_spregfile", ".")

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
        create_mock_ram_class("spregfile", macrodw, macroaw, port_map)
    ]

    wrapper_file = Path("la_spregfile.v")
    spregfile_lib.write_lambdalib(wrapper_file, memories)

    # Generate macro file that instantiates the wrapper
    macro_file = Path("spregfile_macro.v")
    macro_content = f'''
module spregfile(
    input clk,
    input [{macroaw-1}:0] mem_addr,
    input [{macrodw-1}:0] mem_din,
    input ce_in,
    input we_in,
    input [{macrodw-1}:0] mem_wmask,
    output [{macrodw-1}:0] mem_dout
);
    la_spregfile_impl #(
        .AW({macroaw}),
        .DW({macrodw})
    ) memory (
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
    project = Sim(SpregfileTbDesign("icarus",
                                    wrapper_file=wrapper_file.resolve(),
                                    macro_file=macro_file.resolve()))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=False)
    project.set_flow("dvflow-icarus-cocotb")
    project.option.set_env("COCOTB_MACROAW", str(macroaw))
    assert project.run()


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
def test_dpram_cocotb_functional(macroaw, macrodw, aw, dw):
    """
    Run DPRAM cocotb functional tests with generated template.

    Tests the dynamically generated la_dpram wrapper with various
    address and data widths, verifying write/read operations and
    write masking with separate read and write clocks.
    """
    pytest.importorskip("cocotb")

    class DpramTbDesign(Design):
        """Testbench design for DPRAM cocotb functional tests"""

        def __init__(self, simulator: str = "icarus", wrapper_file=None, macro_file=None):
            super().__init__("testbench")
            self.set_dataroot("testdata", __file__)

            with self.active_dataroot("testdata"):
                with self.active_fileset("testbench.cocotb"):
                    self.set_topmodule("la_dpram")
                    self.set_param("AW", str(aw))
                    self.set_param("DW", str(dw))
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")
                    # Add cocotb test procedures
                    self.add_file(Path(__file__).parent / "cocotb_tests" / "test_dpram.py",
                                  filetype="python")
                    # Add generated wrapper and macro
                    self.add_file(str(wrapper_file), filetype="verilog")
                    self.add_file(str(macro_file), filetype="verilog")
                    self.add_depfileset(Dpram(), "rtl.impl")

    # Generate DPRAM template via write_lambdalib
    dpram_lib = RAMLib("la_dpram", ".")

    # Create mock RAM with specified AW and DW
    # Note: These port mappings reference signals within the WORD generate block
    port_map = [
        ("wr_clk", "wr_clk"),
        ("wr_addr", "wr_mem_addr"),
        ("wr_ce", "wr_ce_in"),
        ("wr_din", "mem_din"),
        ("wr_we", "we_in"),
        ("wr_wmask", "mem_wmask"),
        ("rd_clk", "rd_clk"),
        ("rd_addr", "rd_mem_addr"),
        ("rd_ce", "rd_ce_in"),
        ("rd_dout", "mem_dout"),
    ]

    memories = [
        create_mock_ram_class("dpram", macrodw, macroaw, port_map)
    ]

    wrapper_file = Path("la_dpram.v")
    dpram_lib.write_lambdalib(wrapper_file, memories)

    # Generate macro file that instantiates the wrapper
    macro_file = Path("dpram_macro.v")
    macro_content = f'''
module dpram(
    input wr_clk,
    input [{macroaw-1}:0] wr_addr,
    input [{macrodw-1}:0] wr_din,
    input wr_ce,
    input wr_we,
    input [{macrodw-1}:0] wr_wmask,
    input rd_clk,
    input [{macroaw-1}:0] rd_addr,
    input rd_ce,
    output [{macrodw-1}:0] rd_dout
);
    la_dpram_impl  #(
        .AW({macroaw}),
        .DW({macrodw})
    ) memory (
        .wr_clk(wr_clk),
        .wr_ce(wr_ce),
        .wr_we(wr_we),
        .wr_wmask(wr_wmask),
        .wr_addr(wr_addr),
        .wr_din(wr_din),
        .rd_clk(rd_clk),
        .rd_ce(rd_ce),
        .rd_addr(rd_addr),
        .rd_dout(rd_dout)
    );
endmodule
'''
    macro_file.write_text(macro_content)
    # Run cocotb simulation via SiliconCompiler
    project = Sim(DpramTbDesign("icarus",
                                wrapper_file=wrapper_file.resolve(),
                                macro_file=macro_file.resolve()))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=False)
    project.set_flow("dvflow-icarus-cocotb")
    project.option.set_env("COCOTB_MACROAW", str(macroaw))
    assert project.run()


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
def test_tdpram_cocotb_functional(macroaw, macrodw, aw, dw):
    """
    Run TDPRAM cocotb functional tests with generated template.

    Tests the dynamically generated la_tdpram wrapper with various
    address and data widths, verifying write/read operations and
    write masking with two independent ports.
    """
    pytest.importorskip("cocotb")

    class TdpramTbDesign(Design):
        """Testbench design for TDPRAM cocotb functional tests"""

        def __init__(self, simulator: str = "icarus", wrapper_file=None, macro_file=None):
            super().__init__("testbench")
            self.set_dataroot("testdata", __file__)

            with self.active_dataroot("testdata"):
                with self.active_fileset("testbench.cocotb"):
                    self.set_topmodule("la_tdpram")
                    self.set_param("AW", str(aw))
                    self.set_param("DW", str(dw))
                    self.add_depfileset(SimCmdFiles(), f"{simulator}_sim")
                    # Add cocotb test procedures
                    self.add_file(Path(__file__).parent / "cocotb_tests" / "test_tdpram.py",
                                  filetype="python")
                    # Add generated wrapper and macro
                    self.add_file(str(wrapper_file), filetype="verilog")
                    self.add_file(str(macro_file), filetype="verilog")
                    self.add_depfileset(Tdpram(), "rtl.impl")

    # Generate TDPRAM template via write_lambdalib
    tdpram_lib = RAMLib("la_tdpram", ".")

    # Create mock RAM with specified AW and DW
    # Note: These port mappings reference signals within the WORD generate block
    port_map = [
        ("clk_a", "clk_a"),
        ("ce_a", "ce_in_A"),
        ("we_a", "we_in_A"),
        ("wmask_a", "mem_wmaskA"),
        ("addr_a", "mem_addrA"),
        ("din_a", "mem_dinA"),
        ("dout_a", "mem_doutA"),
        ("clk_b", "clk_b"),
        ("ce_b", "ce_in_B"),
        ("we_b", "we_in_B"),
        ("wmask_b", "mem_wmaskB"),
        ("addr_b", "mem_addrB"),
        ("din_b", "mem_dinB"),
        ("dout_b", "mem_doutB"),
    ]

    memories = [
        create_mock_ram_class("tdpram", macrodw, macroaw, port_map)
    ]

    wrapper_file = Path("la_tdpram.v")
    tdpram_lib.write_lambdalib(wrapper_file, memories)

    # Generate macro file that instantiates the wrapper
    macro_file = Path("tdpram_macro.v")
    macro_content = f'''
module tdpram(
    input clk_a,
    input ce_a,
    input we_a,
    input [{macrodw-1}:0] wmask_a,
    input [{macroaw-1}:0] addr_a,
    input [{macrodw-1}:0] din_a,
    output [{macrodw-1}:0] dout_a,
    input clk_b,
    input ce_b,
    input we_b,
    input [{macrodw-1}:0] wmask_b,
    input [{macroaw-1}:0] addr_b,
    input [{macrodw-1}:0] din_b,
    output [{macrodw-1}:0] dout_b
);
    la_tdpram_impl #(
        .AW({macroaw}),
        .DW({macrodw})
    ) memory (
        .clk_a(clk_a),
        .ce_a(ce_a),
        .we_a(we_a),
        .wmask_a(wmask_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),
        .clk_b(clk_b),
        .ce_b(ce_b),
        .we_b(we_b),
        .wmask_b(wmask_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );
endmodule
'''
    macro_file.write_text(macro_content)
    # Run cocotb simulation via SiliconCompiler
    project = Sim(TdpramTbDesign("icarus",
                                 wrapper_file=wrapper_file.resolve(),
                                 macro_file=macro_file.resolve()))
    project.add_fileset("testbench.cocotb")
    use_cocotb(project=project, trace=False)
    project.set_flow("dvflow-icarus-cocotb")
    project.option.set_env("COCOTB_MACROAW", str(macroaw))
    assert project.run()
