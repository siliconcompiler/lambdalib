"""
Linting tests for memory templates using SiliconCompiler.

Tests the generated memory wrapper templates using linters (slang and verilator)
to verify syntax and semantic correctness.
"""

import pytest

from pathlib import Path
from siliconcompiler import Design, Project
from siliconcompiler.flows import lintflow
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
            port_names = [port for port, _ in ports]
            is_dual_port = any('wr_' in p or 'rd_' in p for p in port_names)
            is_true_dual_port = any('_a' in p or '_b' in p for p in port_names)

            if is_true_dual_port:
                return "16'b1_1_0_10_101_1_0_10_100"
            elif is_dual_port:
                return "14'b1_1_0_10_100_1_10_100"
            else:
                return "8'b1_0_1_10_101"

        def get_ram_defaultctrl_width(self) -> int:
            """Returns the width of the default control signal for the RAM cell."""
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


@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_spram_lint_slang(macroaw, macrodw, aw, dw, spram_macro):
    """Test SPRAM template linting with slang linter."""
    class SpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_slang")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Spram(), "rtl.impl")

    spram_lib = RAMLib("la_spram", ".")
    port_map = [
        ("clk", "clk"),
        ("mem_addr", "mem_addr"),
        ("ce_in", "ce_in"),
        ("mem_dout", "mem_dout"),
        ("we_in", "we_in"),
        ("mem_wmask", "mem_wmask"),
        ("mem_din", "mem_din")
    ]
    memories = [create_mock_ram_class("spram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_spram.v")
    spram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("spram_macro.v")
    macro_file.write_text(spram_macro(macroaw, macrodw))

    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_dpram_lint_slang(macroaw, macrodw, aw, dw, dpram_macro):
    """Test DPRAM template linting with slang linter."""
    class DpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_slang")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Dpram(), "rtl.impl")

    dpram_lib = RAMLib("la_dpram", ".")
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
    memories = [create_mock_ram_class("dpram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_dpram.v")
    dpram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("dpram_macro.v")
    macro_file.write_text(dpram_macro(macroaw, macrodw))

    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_spregfile_lint_slang(macroaw, macrodw, aw, dw, spregfile_macro):
    """Test SPREGFILE template linting with slang linter."""
    class SpregfileLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_slang")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Spregfile(), "rtl.impl")

    spregfile_lib = RAMLib("la_spregfile", ".")
    port_map = [
        ("clk", "clk"),
        ("mem_addr", "mem_addr"),
        ("ce_in", "ce_in"),
        ("mem_dout", "mem_dout"),
        ("we_in", "we_in"),
        ("mem_wmask", "mem_wmask"),
        ("mem_din", "mem_din")
    ]
    memories = [create_mock_ram_class("spregfile", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_spregfile.v")
    spregfile_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("spregfile_macro.v")
    macro_file.write_text(spregfile_macro(macroaw, macrodw))

    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(),
                                 macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_tdpram_lint_slang(macroaw, macrodw, aw, dw, tdpram_macro):
    """Test TDPRAM template linting with slang linter."""
    class TdpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_slang")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Tdpram(), "rtl.impl")

    tdpram_lib = RAMLib("la_tdpram", ".")
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
    memories = [create_mock_ram_class("tdpram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_tdpram.v")
    tdpram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("tdpram_macro.v")
    macro_file.write_text(tdpram_macro(macroaw, macrodw))

    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_spram_lint_verilator(macroaw, macrodw, aw, dw, spram_macro):
    """Test SPRAM template linting with verilator."""
    class SpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_verilator")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Spram(), "rtl.impl")

    spram_lib = RAMLib("la_spram", ".")
    port_map = [
        ("clk", "clk"),
        ("mem_addr", "mem_addr"),
        ("ce_in", "ce_in"),
        ("mem_dout", "mem_dout"),
        ("we_in", "we_in"),
        ("mem_wmask", "mem_wmask"),
        ("mem_din", "mem_din")
    ]
    memories = [create_mock_ram_class("spram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_spram.v")
    spram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("spram_macro.v")
    macro_file.write_text(spram_macro(macroaw, macrodw))

    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_dpram_lint_verilator(macroaw, macrodw, aw, dw, dpram_macro):
    """Test DPRAM template linting with verilator."""
    class DpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_verilator")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Dpram(), "rtl.impl")

    dpram_lib = RAMLib("la_dpram", ".")
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
    memories = [create_mock_ram_class("dpram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_dpram.v")
    dpram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("dpram_macro.v")
    macro_file.write_text(dpram_macro(macroaw, macrodw))

    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_spregfile_lint_verilator(macroaw, macrodw, aw, dw, spregfile_macro):
    """Test SPREGFILE template linting with verilator."""
    class SpregfileLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_verilator")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Spregfile(), "rtl.impl")

    spregfile_lib = RAMLib("la_spregfile", ".")
    port_map = [
        ("clk", "clk"),
        ("mem_addr", "mem_addr"),
        ("ce_in", "ce_in"),
        ("mem_dout", "mem_dout"),
        ("we_in", "we_in"),
        ("mem_wmask", "mem_wmask"),
        ("mem_din", "mem_din")
    ]
    memories = [create_mock_ram_class("spregfile", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_spregfile.v")
    spregfile_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("spregfile_macro.v")
    macro_file.write_text(spregfile_macro(macroaw, macrodw))

    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(),
                                 macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
@pytest.mark.parametrize("macroaw, macrodw, aw, dw", [
    # Exact match tests
    (7, 8, 7, 8),        # 128x8 macro with 128x8 wrapper
    (8, 32, 8, 32),      # 256x32 macro with 256x32 wrapper
    (9, 64, 9, 64),      # 512x64 macro with 512x64 wrapper
    (10, 128, 10, 128),  # 1024x128 macro with 1024x128 wrapper
    # Larger macro tests (macro >= wrapper)
    (9, 64, 7, 8),       # 512x64 macro with 128x8 wrapper
    (10, 32, 8, 32),     # 1024x32 macro with 256x32 wrapper
    (9, 64, 8, 32),      # 512x64 macro with 256x32 wrapper
    (11, 128, 8, 32),    # 2048x128 macro with 256x32 wrapper
    (10, 128, 7, 16),    # 1024x128 macro with 128x16 wrapper
])
def test_tdpram_lint_verilator(macroaw, macrodw, aw, dw, tdpram_macro):
    """Test TDPRAM template linting with verilator."""
    class TdpramLintDesign(Design):
        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_verilator")
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                self.add_depfileset(Tdpram(), "rtl.impl")

    tdpram_lib = RAMLib("la_tdpram", ".")
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
    memories = [create_mock_ram_class("tdpram", macrodw, macroaw, port_map)]
    wrapper_file = Path("la_tdpram.v")
    tdpram_lib.write_lambdalib(wrapper_file, memories)

    macro_file = Path("tdpram_macro.v")
    macro_file.write_text(tdpram_macro(macroaw, macrodw))

    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()
