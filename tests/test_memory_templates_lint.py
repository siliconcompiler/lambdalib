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


@pytest.mark.timeout(120)
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
def test_spram_lint_slang(macroaw, macrodw, aw, dw, spram_macro):
    """Test SPRAM template linting with slang linter.

    Generates SPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class SpramLintDesign(Design):
        """Design for SPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spram_impl)
                self.add_depfileset(Spram(), "rtl.impl")

    # Generate SPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("spram_macro.v")
    macro_file.write_text(spram_macro(macroaw, macrodw))

    # Run slang linting via SiliconCompiler
    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_dpram_lint_slang(macroaw, macrodw, aw, dw, dpram_macro):
    """Test DPRAM template linting with slang linter.

    Generates DPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class DpramLintDesign(Design):
        """Design for DPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes dpram_impl)
                self.add_depfileset(Dpram(), "rtl.impl")

    # Generate DPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("dpram_macro.v")
    macro_file.write_text(dpram_macro(macroaw, macrodw))

    # Run slang linting via SiliconCompiler
    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_spram_lint_verilator(macroaw, macrodw, aw, dw, spram_macro):
    """Test SPRAM template linting with verilator.

    Generates SPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class SpramLintDesign(Design):
        """Design for SPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spram_impl)
                self.add_depfileset(Spram(), "rtl.impl")

    # Generate SPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("spram_macro.v")
    macro_file.write_text(spram_macro(macroaw, macrodw))

    # Run verilator linting via SiliconCompiler
    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_dpram_lint_verilator(macroaw, macrodw, aw, dw, dpram_macro):
    """Test DPRAM template linting with verilator.

    Generates DPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class DpramLintDesign(Design):
        """Design for DPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes dpram_impl)
                self.add_depfileset(Dpram(), "rtl.impl")

    # Generate DPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("dpram_macro.v")
    macro_file.write_text(dpram_macro(macroaw, macrodw))

    # Run verilator linting via SiliconCompiler
    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_spregfile_lint_slang(macroaw, macrodw, aw, dw, spregfile_macro):
    """Test SPREGFILE template linting with slang linter.

    Generates SPREGFILE template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class SpregfileLintDesign(Design):
        """Design for SPREGFILE slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spregfile_impl)
                self.add_depfileset(Spregfile(), "rtl.impl")

    # Generate SPREGFILE template
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

    # Generate macro file using fixture
    macro_file = Path("spregfile_macro.v")
    macro_file.write_text(spregfile_macro(macroaw, macrodw))

    # Run slang linting via SiliconCompiler
    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_tdpram_lint_slang(macroaw, macrodw, aw, dw, tdpram_macro):
    """Test TDPRAM template linting with slang linter.

    Generates TDPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class TdpramLintDesign(Design):
        """Design for TDPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes tdpram_impl)
                self.add_depfileset(Tdpram(), "rtl.impl")

    # Generate TDPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("tdpram_macro.v")
    macro_file.write_text(tdpram_macro(macroaw, macrodw))

    # Run slang linting via SiliconCompiler
    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_spregfile_lint_verilator(macroaw, macrodw, aw, dw, spregfile_macro):
    """Test SPREGFILE template linting with verilator.

    Generates SPREGFILE template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class SpregfileLintDesign(Design):
        """Design for SPREGFILE verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spregfile_impl)
                self.add_depfileset(Spregfile(), "rtl.impl")

    # Generate SPREGFILE template
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

    # Generate macro file using fixture
    macro_file = Path("spregfile_macro.v")
    macro_file.write_text(spregfile_macro(macroaw, macrodw))

    # Run verilator linting via SiliconCompiler
    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_tdpram_lint_verilator(macroaw, macrodw, aw, dw, tdpram_macro):
    """Test TDPRAM template linting with verilator.

    Generates TDPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class TdpramLintDesign(Design):
        """Design for TDPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes tdpram_impl)
                self.add_depfileset(Tdpram(), "rtl.impl")

    # Generate TDPRAM template
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

    # Generate macro file using fixture
    macro_file = Path("tdpram_macro.v")
    macro_file.write_text(tdpram_macro(macroaw, macrodw))

    # Run verilator linting via SiliconCompiler
    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()
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


@pytest.mark.timeout(120)
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
def test_spram_lint_slang(macroaw, macrodw, aw, dw):
    """Test SPRAM template linting with slang linter.

    Generates SPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class SpramLintDesign(Design):
        """Design for SPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spram_impl)
                self.add_depfileset(Spram(), "rtl.impl")

    # Generate SPRAM template
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

    # Generate macro file that instantiates the wrapper
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

    # Run slang linting via SiliconCompiler
    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_dpram_lint_slang(macroaw, macrodw, aw, dw):
    """Test DPRAM template linting with slang linter.

    Generates DPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class DpramLintDesign(Design):
        """Design for DPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes dpram_impl)
                self.add_depfileset(Dpram(), "rtl.impl")

    # Generate DPRAM template
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

    # Run slang linting via SiliconCompiler
    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_spram_lint_verilator(macroaw, macrodw, aw, dw):
    """Test SPRAM template linting with verilator.

    Generates SPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class SpramLintDesign(Design):
        """Design for SPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spram_impl)
                self.add_depfileset(Spram(), "rtl.impl")

    # Generate SPRAM template
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

    # Generate macro file that instantiates the wrapper
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

    # Run verilator linting via SiliconCompiler
    design = SpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_dpram_lint_verilator(macroaw, macrodw, aw, dw):
    """Test DPRAM template linting with verilator.

    Generates DPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class DpramLintDesign(Design):
        """Design for DPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("dpram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_dpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes dpram_impl)
                self.add_depfileset(Dpram(), "rtl.impl")

    # Generate DPRAM template
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

    # Run verilator linting via SiliconCompiler
    design = DpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_spregfile_lint_slang(macroaw, macrodw, aw, dw):
    """Test SPREGFILE template linting with slang linter.

    Generates SPREGFILE template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class SpregfileLintDesign(Design):
        """Design for SPREGFILE slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spregfile_impl)
                self.add_depfileset(Spregfile(), "rtl.impl")

    # Generate SPREGFILE template
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

    # Run slang linting via SiliconCompiler
    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.timeout(120)
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
def test_tdpram_lint_slang(macroaw, macrodw, aw, dw):
    """Test TDPRAM template linting with slang linter.

    Generates TDPRAM template with various configurations and lints
    using the slang SystemVerilog linter via SiliconCompiler.
    """
    class TdpramLintDesign(Design):
        """Design for TDPRAM slang linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_slang")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes tdpram_impl)
                self.add_depfileset(Tdpram(), "rtl.impl")

    # Generate TDPRAM template
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

    # Run slang linting via SiliconCompiler
    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="slang"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_spregfile_lint_verilator(macroaw, macrodw, aw, dw):
    """Test SPREGFILE template linting with verilator.

    Generates SPREGFILE template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class SpregfileLintDesign(Design):
        """Design for SPREGFILE verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("spregfile_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_spregfile")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes spregfile_impl)
                self.add_depfileset(Spregfile(), "rtl.impl")

    # Generate SPREGFILE template
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

    # Run verilator linting via SiliconCompiler
    design = SpregfileLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()


@pytest.mark.eda
@pytest.mark.timeout(120)
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
def test_tdpram_lint_verilator(macroaw, macrodw, aw, dw):
    """Test TDPRAM template linting with verilator.

    Generates TDPRAM template with various configurations and lints
    using verilator via SiliconCompiler.
    """
    class TdpramLintDesign(Design):
        """Design for TDPRAM verilator linting"""

        def __init__(self, wrapper_file=None, macro_file=None):
            super().__init__("tdpram_lint_verilator")
            
            with self.active_fileset("rtl"):
                self.set_topmodule("la_tdpram")
                self.set_param("AW", str(aw))
                self.set_param("DW", str(dw))
                # Add generated wrapper and macro
                self.add_file(str(wrapper_file), filetype="verilog")
                self.add_file(str(macro_file), filetype="verilog")
                # Add implementation dependencies (includes tdpram_impl)
                self.add_depfileset(Tdpram(), "rtl.impl")

    # Generate TDPRAM template
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

    # Run verilator linting via SiliconCompiler
    design = TdpramLintDesign(wrapper_file=wrapper_file.resolve(), macro_file=macro_file.resolve())
    project = Project(design)
    project.add_fileset("rtl")
    project.set_flow(lintflow.LintFlow(tool="verilator"))
    assert project.run()
