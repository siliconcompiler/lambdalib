"""
Test memory templates by generating complete libraries using write_lambdalib
and verifying functionality with hard macros (using *_impl versions).
"""

import os
import re
import tempfile
import subprocess
from pathlib import Path
import pytest

from lambdalib.ramlib._common import RAMLib


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


def extract_module_instantiation(content, module_name):
    """Extract module instantiation block from Verilog content"""
    # Match pattern: module_name memory (...);
    pattern = rf"{module_name}\s+\w+\s*\((.*?)\);"
    match = re.search(pattern, content, re.DOTALL)
    if match:
        return match.group(1)
    return None


def verify_port_connections(instantiation_block, expected_ports):
    """Verify that all expected port connections exist in instantiation.
    
    Args:
        instantiation_block: Port list string from module instantiation
        expected_ports: Dict of {port_name: expected_connection_signal}
    
    Returns:
        Dict with verification results
    """
    results = {"found": {}, "missing": []}
    
    for port_name, expected_signal in expected_ports.items():
        # Match .port_name(signal_name) pattern
        pattern = rf"\.{port_name}\s*\(\s*([^)]+)\s*\)"
        match = re.search(pattern, instantiation_block)
        
        if match:
            actual_signal = match.group(1).strip()
            results["found"][port_name] = actual_signal
        else:
            results["missing"].append(port_name)
    
    return results


def extract_parameter_selection(content, macro_name):
    """Extract MEM_WIDTH and MEM_DEPTH assignments for a specific macro"""
    # Find lines like: (MEM_PROP == "macro_name") ? width :
    # These can span multiple lines
    escaped_name = re.escape(macro_name)
    
    width_search = re.search(rf'localparam\s+MEM_WIDTH\s*=.*?\(MEM_PROP\s*==\s*"{escaped_name}"\)\s*\?\s*(\d+)', 
                            content, re.DOTALL)
    depth_search = re.search(rf'localparam\s+MEM_DEPTH\s*=.*?\(MEM_PROP\s*==\s*"{escaped_name}"\)\s*\?\s*(\d+)', 
                            content, re.DOTALL)
    
    width = int(width_search.group(1)) if width_search else None
    depth = int(depth_search.group(1)) if depth_search else None
    
    return {"width": width, "depth": depth}


def test_write_spram_single_macro(tmp_path):
    """Test writing a spram library using write_lambdalib with single macro"""
    spram_lib = RAMLib("la_spram", ".")
    
    # Port mapping following the template's expected signals
    port_map = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    
    memories = [
        create_mock_ram_class("test_spram_512x32", 32, 9, port_map)
    ]
    
    out = tmp_path / "la_spram_test.v"
    spram_lib.write_lambdalib(out, memories)
    
    assert out.exists()
    content = out.read_text()
    
    # Verify module structure
    assert "module la_spram" in content
    
    # Verify parameter selection logic includes our macro
    assert 'test_spram_512x32' in content
    assert 'MEM_WIDTH' in content
    assert 'MEM_DEPTH' in content
    
    # Verify parameter values are correct for this macro
    params = extract_parameter_selection(content, "test_spram_512x32")
    assert params["width"] == 32, f"Expected width 32, got {params['width']}"
    assert params["depth"] == 9, f"Expected depth 9, got {params['depth']}"
    
    # Verify port instantiation with correct connections
    inst = extract_module_instantiation(content, "test_spram_512x32")
    assert inst is not None, "Could not find test_spram_512x32 instantiation"
    
    # Expected port connections: macro port -> wrapper signal
    expected_connections = {
        "clk": "clk",
        "addr_in": "mem_addr",
        "ce_in": "ce_in",
        "rd_out": "mem_dout",
        "we_in": "we_in",
        "w_mask_in": "mem_wmask",
        "wd_in": "mem_din"
    }
    
    results = verify_port_connections(inst, expected_connections)
    assert len(results["missing"]) == 0, f"Missing port connections: {results['missing']}"
    
    # Verify registered select is used for output gating
    assert "selected_reg" in content
    assert "always @(posedge clk)" in content


def test_write_spram_multi_macro_address_expansion(tmp_path):
    """Test spram with address expansion (multiple macros for address space)"""
    spram_lib = RAMLib("la_spram", ".")
    
    port_map = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    
    # Multiple macros at same width, different depths - requires address decoder
    memories = [
        create_mock_ram_class("spram_512x32", 32, 9, port_map),
        create_mock_ram_class("spram_1024x32", 32, 10, port_map),
    ]
    
    out = tmp_path / "la_spram_multi.v"
    spram_lib.write_lambdalib(out, memories)
    
    content = out.read_text()
    
    # Verify both macros are in selection logic
    assert "spram_512x32" in content
    assert "spram_1024x32" in content
    
    # Verify parameter values for each macro
    params_512 = extract_parameter_selection(content, "spram_512x32")
    params_1024 = extract_parameter_selection(content, "spram_1024x32")
    
    assert params_512["width"] == 32 and params_512["depth"] == 9
    assert params_1024["width"] == 32 and params_1024["depth"] == 10
    
    # Address expansion logic should be present
    assert "MEM_ADDRS" in content
    assert "ADDR" in content
    
    # Should have address decoder for selecting between macros
    # Pattern: addr[AW-1:MEM_DEPTH] == a (selects which macro)
    assert "addr[" in content and "MEM_DEPTH]" in content


def test_write_spram_multi_macro_width_expansion(tmp_path):
    """Test spram with data width expansion (multiple macros packed)"""
    spram_lib = RAMLib("la_spram", ".")
    
    port_map = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    
    # Multiple macros at same depth, different widths - requires word multiplexing
    memories = [
        create_mock_ram_class("spram_512x8", 8, 9, port_map),
        create_mock_ram_class("spram_512x16", 16, 9, port_map),
        create_mock_ram_class("spram_512x32", 32, 9, port_map),
    ]
    
    out = tmp_path / "la_spram_wide.v"
    spram_lib.write_lambdalib(out, memories)
    
    content = out.read_text()
    
    # Verify all macros are in selection logic
    assert "spram_512x8" in content
    assert "spram_512x16" in content
    assert "spram_512x32" in content
    
    # Verify parameter values match specifications
    params_8 = extract_parameter_selection(content, "spram_512x8")
    params_16 = extract_parameter_selection(content, "spram_512x16")
    params_32 = extract_parameter_selection(content, "spram_512x32")
    
    assert params_8["width"] == 8 and params_8["depth"] == 9
    assert params_16["width"] == 16 and params_16["depth"] == 9
    assert params_32["width"] == 32 and params_32["depth"] == 9
    
    # Word packing logic for data width expansion
    assert "WORD" in content
    
    # Should have bit selection logic to pack/unpack across macros
    assert "DW" in content or "din[" in content


def test_write_dpram_single_macro(tmp_path):
    """Test writing a dpram library with write/read port separation"""
    dpram_lib = RAMLib("la_dpram", ".")
    
    port_map = [
        ("wr_clk", "wr_clk"),
        ("wr_ce", "wr_ce"),
        ("wr_we", "we_in"),
        ("wr_wmask", "mem_wmask"),
        ("wr_addr", "wr_mem_addr"),
        ("wr_din", "mem_din"),
        ("rd_clk", "rd_clk"),
        ("rd_ce", "rd_ce"),
        ("rd_addr", "rd_mem_addr"),
        ("rd_dout", "mem_dout"),
    ]
    
    memories = [
        create_mock_ram_class("test_dpram_512x32", 32, 9, port_map)
    ]
    
    out = tmp_path / "la_dpram_test.v"
    dpram_lib.write_lambdalib(out, memories)
    
    assert out.exists()
    content = out.read_text()
    
    # Verify module exists and has dual clock interface
    assert "module la_dpram" in content
    assert "test_dpram_512x32" in content
    
    # Verify dual port interface is present
    assert "wr_clk" in content
    assert "rd_clk" in content
    assert "wr_addr" in content
    assert "rd_addr" in content
    
    # Verify parameter selection
    params = extract_parameter_selection(content, "test_dpram_512x32")
    assert params["width"] == 32
    assert params["depth"] == 9
    
    # Verify port instantiation
    inst = extract_module_instantiation(content, "test_dpram_512x32")
    assert inst is not None, "Could not find test_dpram_512x32 instantiation"
    
    # Verify correct port connections for write and read paths
    expected_dpram_connections = {
        "wr_clk": "wr_clk",
        "wr_ce": "wr_ce",
        "wr_we": "we_in",
        "wr_wmask": "mem_wmask",
        "wr_addr": "wr_mem_addr",
        "wr_din": "mem_din",
        "rd_clk": "rd_clk",
        "rd_ce": "rd_ce",
        "rd_addr": "rd_mem_addr",
        "rd_dout": "mem_dout"
    }
    
    results = verify_port_connections(inst, expected_dpram_connections)
    assert len(results["missing"]) == 0, f"Missing port connections: {results['missing']}"
    
    # Verify each connection matches specification
    for port_name, expected_signal in expected_dpram_connections.items():
        actual_signal = results["found"].get(port_name)
        assert actual_signal == expected_signal, \
            f"Port {port_name}: expected {expected_signal}, got {actual_signal}"
    
    # Verify registered selects for dual clocks (read side needs registration)
    assert "re_selected_reg" in content
    assert "@(posedge rd_clk)" in content


def test_write_dpram_independent_clocks(tmp_path):
    """Test that DPRAM properly handles independent read/write clocks"""
    dpram_lib = RAMLib("la_dpram", ".")
    
    port_map = [
        ("wr_clk", "wr_clk"),
        ("wr_ce", "wr_ce"),
        ("wr_we", "we_in"),
        ("wr_wmask", "mem_wmask"),
        ("wr_addr", "wr_mem_addr"),
        ("wr_din", "mem_din"),
        ("rd_clk", "rd_clk"),
        ("rd_ce", "rd_ce"),
        ("rd_addr", "rd_mem_addr"),
        ("rd_dout", "mem_dout"),
    ]
    
    memories = [
        create_mock_ram_class("dpram_512x32", 32, 9, port_map)
    ]
    
    out = tmp_path / "la_dpram_clocks.v"
    dpram_lib.write_lambdalib(out, memories)
    
    content = out.read_text()
    
    # Verify separate clock domain signals are present
    assert "input wr_clk" in content
    assert "input rd_clk" in content
    assert "input wr_ce" in content
    assert "input rd_ce" in content
    
    # Verify read-side registered select (synchronized to rd_clk)
    assert "always @(posedge rd_clk)" in content
    assert "re_selected_reg" in content
    
    # Verify instantiation has correct clock connections
    inst = extract_module_instantiation(content, "dpram_512x32")
    assert inst is not None, "Could not find dpram_512x32 instantiation"
    
    # Verify separate write and read clock connections with correct signals
    expected_clock_connections = {
        "wr_clk": "wr_clk",
        "rd_clk": "rd_clk",
        "wr_ce": "wr_ce",
        "rd_ce": "rd_ce",
        "wr_addr": "wr_mem_addr",
        "rd_addr": "rd_mem_addr"
    }
    
    results = verify_port_connections(inst, expected_clock_connections)
    assert len(results["missing"]) == 0, f"Missing clock/address connections: {results['missing']}"
    
    # Verify write side uses wr_clk and read side uses rd_clk
    assert results["found"]["wr_clk"] == "wr_clk"
    assert results["found"]["rd_clk"] == "rd_clk"


def test_write_tdpram_both_ports_readable(tmp_path):
    """Test true dual port RAM with both ports readable"""
    tdpram_lib = RAMLib("la_tdpram", ".")
    
    port_map = [
        ("clk_a", "clk_a"),
        ("ce_a", "ce_a"),
        ("we_a", "we_a"),
        ("wmask_a", "wmask_a"),
        ("addr_a", "addr_a"),
        ("din_a", "din_a"),
        ("dout_a", "dout_a"),
        ("clk_b", "clk_b"),
        ("ce_b", "ce_b"),
        ("we_b", "we_b"),
        ("wmask_b", "wmask_b"),
        ("addr_b", "addr_b"),
        ("din_b", "din_b"),
        ("dout_b", "dout_b"),
    ]
    
    memories = [
        create_mock_ram_class("test_tdpram_512x32", 32, 9, port_map)
    ]
    
    out = tmp_path / "la_tdpram_test.v"
    tdpram_lib.write_lambdalib(out, memories)
    
    assert out.exists()
    content = out.read_text()
    
    # Verify module structure
    assert "module la_tdpram" in content
    assert "test_tdpram_512x32" in content
    
    # Verify both ports are present with independent clocks (may have whitespace)
    assert "clk_a" in content
    assert "clk_b" in content
    assert "addr_a" in content
    assert "addr_b" in content
    assert "dout_a" in content
    assert "dout_b" in content
    
    # Verify parameter selection
    params = extract_parameter_selection(content, "test_tdpram_512x32")
    assert params["width"] == 32
    assert params["depth"] == 9
    
    # Verify port instantiation with correct connections
    inst = extract_module_instantiation(content, "test_tdpram_512x32")
    assert inst is not None, "Could not find test_tdpram_512x32 instantiation"
    
    # Both ports should be independently accessible
    assert ".clk_a(clk_a)" in inst
    assert ".clk_b(clk_b)" in inst
    assert ".addr_a(addr_a)" in inst
    assert ".addr_b(addr_b)" in inst
    assert ".dout_a(dout_a)" in inst
    assert ".dout_b(dout_b)" in inst
    
    # Verify dual registered selects for both port clocks
    assert "selectedA_reg" in content
    assert "selectedB_reg" in content
    assert "@(posedge clk_a)" in content
    assert "@(posedge clk_b)" in content


def test_macro_selection_by_size(tmp_path):
    """Verify correct macro selection based on required size"""
    spram_lib = RAMLib("la_spram", ".")
    
    # Define macros with increasing capacity
    port_map = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    
    memories = [
        create_mock_ram_class("spram_256x8", 8, 8, port_map),      # 2KB
        create_mock_ram_class("spram_512x16", 16, 9, port_map),    # 8KB
        create_mock_ram_class("spram_1024x32", 32, 10, port_map),  # 32KB
    ]
    
    out = tmp_path / "la_spram_selection.v"
    spram_lib.write_lambdalib(out, memories)
    
    content = out.read_text()
    
    # Verify all macros are present in selection logic
    assert "spram_256x8" in content
    assert "spram_512x16" in content
    assert "spram_1024x32" in content
    
    # Verify each macro has correct width and depth parameters
    params_256 = extract_parameter_selection(content, "spram_256x8")
    params_512 = extract_parameter_selection(content, "spram_512x16")
    params_1024 = extract_parameter_selection(content, "spram_1024x32")
    
    assert params_256["width"] == 8 and params_256["depth"] == 8
    assert params_512["width"] == 16 and params_512["depth"] == 9
    assert params_1024["width"] == 32 and params_1024["depth"] == 10
    
    # Verify all three instantiations are protected by conditional selection
    assert "if (MEM_PROP == \"spram_256x8\")" in content
    assert "if (MEM_PROP == \"spram_512x16\")" in content
    assert "if (MEM_PROP == \"spram_1024x32\")" in content


def test_port_mapping_correct_generation(tmp_path):
    """Verify port mappings are correctly generated from mock definitions"""
    spram_lib = RAMLib("la_spram", ".")
    
    # Create a memory with specific port mapping that differs from standard names
    port_map = [
        ("my_clk_port", "clk"),
        ("my_addr_port", "mem_addr"),
        ("my_ce_port", "ce_in"),
        ("my_data_out", "mem_dout"),
        ("my_we_port", "we_in"),
        ("my_mask_port", "mem_wmask"),
        ("my_data_in", "mem_din")
    ]
    
    memories = [
        create_mock_ram_class("custom_spram", 32, 10, port_map)
    ]
    
    out = tmp_path / "la_spram_ports.v"
    spram_lib.write_lambdalib(out, memories)
    
    content = out.read_text()
    
    # Verify custom macro name is present
    assert "custom_spram" in content
    
    # Verify port instantiation with exact custom port names
    inst = extract_module_instantiation(content, "custom_spram")
    assert inst is not None, "Could not find custom_spram instantiation"
    
    # Custom port names from the mock should be used in instantiation
    expected_connections = {
        "my_clk_port": "clk",
        "my_addr_port": "mem_addr",
        "my_ce_port": "ce_in",
        "my_data_out": "mem_dout",
        "my_we_port": "we_in",
        "my_mask_port": "mem_wmask",
        "my_data_in": "mem_din"
    }
    
    results = verify_port_connections(inst, expected_connections)
    assert len(results["missing"]) == 0, f"Missing port connections: {results['missing']}"
    
    # Every custom port should be connected to corresponding wrapper signal
    for port_name, actual_signal in results["found"].items():
        expected_signal = expected_connections[port_name]
        assert actual_signal == expected_signal, \
            f"Port {port_name}: expected {expected_signal}, got {actual_signal}"
