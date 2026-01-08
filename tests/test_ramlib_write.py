import pytest
from lambdalib.ramlib._common import RAMLib


def create_mock_ram(name, width, depth, ports):
    ports = {
        port: wire for port, wire in ports
    }
    class MockRAM:
        def get_ram_libcell(self):
            return name

        def get_ram_width(self):
            return width

        def get_ram_depth(self):
            return depth

        def get_ram_ports(self):
            return ports

    return MockRAM


@pytest.fixture
def ramlib():
    return RAMLib("la_spram", ".")


def test_write_lambdalib_asap7(ramlib, tmp_path):
    asap7_spram_port_map_sp = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    memories = [
        create_mock_ram("fakeram7_sp_512x32", 32, 9, asap7_spram_port_map_sp)
    ]
    out = tmp_path / "asap7.v"
    ramlib.write_lambdalib(out, memories)
    assert out.exists()
    content = out.read_text()
    assert "module la_spram" in content
    assert "fakeram7_sp_512x32" in content


def test_write_lambdalib_freepdk45(ramlib, tmp_path):
    freepdk45_spram_port_map = [
        ("clk", "clk"),
        ("addr_in", "mem_addr"),
        ("ce_in", "ce_in"),
        ("rd_out", "mem_dout"),
        ("we_in", "we_in"),
        ("w_mask_in", "mem_wmask"),
        ("wd_in", "mem_din")
    ]
    memories = [
        create_mock_ram("fakeram45_512x32", 32, 9, freepdk45_spram_port_map)
    ]
    out = tmp_path / "freepdk45.v"
    ramlib.write_lambdalib(out, memories)
    assert out.exists()
    content = out.read_text()
    assert "fakeram45_512x32" in content


def test_write_lambdalib_gf180(ramlib, tmp_path):
    gf180_spram_port_map = [
        ("CLK", "clk"),
        ("CEN", "~ce_in"),
        ("GWEN", "~we_in"),
        ("WEN", "~mem_wmask"),
        ("A", "mem_addr"),
        ("D", "mem_din"),
        ("Q", "mem_dout")
    ]
    memories = [
        create_mock_ram("gf180mcu_fd_ip_sram__sram512x8m8wm1", 8, 9, gf180_spram_port_map)
    ]
    out = tmp_path / "gf180.v"
    ramlib.write_lambdalib(out, memories)
    assert out.exists()
    content = out.read_text()
    assert "gf180mcu_fd_ip_sram__sram512x8m8wm1" in content


def test_write_lambdalib_sky130(ramlib, tmp_path):
    sky130_spram_port_map = [
        ("clk0", "clk"),
        ("csb0", "ce_in && we_in"),
        ("web0", "ce_in && we_in"),
        ("wmask0", "{mem_wmask[24], mem_wmask[16], mem_wmask[8], mem_wmask[0]}"),
        ("addr0", "mem_addr"),
        ("din0", "mem_din"),
        ("dout0", ""),
        ("clk1", "clk"),
        ("csb1", "ce_in && ~we_in"),
        ("addr1", "mem_addr"),
        ("dout1", "mem_dout"),
    ]
    memories = [
        create_mock_ram("sky130_sram_1rw1r_64x256_8", 64, 8, sky130_spram_port_map)
    ]
    out = tmp_path / "sky130.v"
    ramlib.write_lambdalib(out, memories)
    assert out.exists()
    content = out.read_text()
    assert "sky130_sram_1rw1r_64x256_8" in content


def test_write_lambdalib_ihp130(ramlib, tmp_path):
    ihp130_spram_port_map = [
        ("A_CLK", "clk"),
        ("A_MEN", "~ce_in"),
        ("A_WEN", "~we_in"),
        ("A_REN", "we_in"),
        ("A_ADDR", "mem_addr"),
        ("A_DIN", "mem_din"),
        ("A_DLY", "1'b1"),
        ("A_DOUT", "mem_dout"),
        ("A_BM", "mem_wmask"),
        ("A_BIST_CLK", "1'b0"),
        ("A_BIST_EN", "1'b0"),
        ("A_BIST_MEN", "1'b0"),
        ("A_BIST_WEN", "1'b0"),
        ("A_BIST_REN", "1'b0"),
        ("A_BIST_ADDR", "'b0"),
        ("A_BIST_DIN", "'b0"),
        ("A_BIST_BM", "'b0")
    ]
    memories = [
        create_mock_ram("RM_IHPSG13_1P_1024x64_c2_bm_bist", 64, 10, ihp130_spram_port_map)
    ]
    out = tmp_path / "ihp130.v"
    ramlib.write_lambdalib(out, memories)
    assert out.exists()
    content = out.read_text()
    assert "RM_IHPSG13_1P_1024x64_c2_bm_bist" in content
