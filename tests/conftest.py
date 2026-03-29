import pytest
import os


@pytest.fixture(autouse=True)
def test_wrapper(tmp_path):
    topdir = os.getcwd()
    os.chdir(tmp_path)
    # Run the test.
    yield
    os.chdir(topdir)


@pytest.fixture
def spram_macro():
    """Fixture to generate SPRAM macro module content."""
    def _generate(aw, dw):
        return f'''
module spram(
    input clk,
    input [{aw-1}:0] mem_addr,
    input [{dw-1}:0] mem_din,
    input ce_in,
    input we_in,
    input [{dw-1}:0] mem_wmask,
    output [{dw-1}:0] mem_dout
);
    la_spram_impl #(
        .AW({aw}),
        .DW({dw})
    ) memory (
        .clk(clk),
        .ce(ce_in),
        .we(we_in),
        .wmask(mem_wmask),
        .addr(mem_addr),
        .din(mem_din),
        .dout(mem_dout),
        .selctrl(1'b0),
        .ctrl(32'h0),
        .status()
    );
endmodule
'''
    return _generate


@pytest.fixture
def dpram_macro():
    """Fixture to generate DPRAM macro module content."""
    def _generate(aw, dw):
        return f'''
module dpram(
    input wr_clk,
    input [{aw-1}:0] wr_addr,
    input [{dw-1}:0] wr_din,
    input wr_ce,
    input wr_we,
    input [{dw-1}:0] wr_wmask,
    input rd_clk,
    input [{aw-1}:0] rd_addr,
    input rd_ce,
    output [{dw-1}:0] rd_dout
);
    la_dpram_impl  #(
        .AW({aw}),
        .DW({dw})
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
        .rd_dout(rd_dout),
        .selctrl(1'b0),
        .ctrl(32'h0),
        .status()
    );
endmodule
'''
    return _generate


@pytest.fixture
def spregfile_macro():
    """Fixture to generate SPREGFILE macro module content."""
    def _generate(aw, dw):
        return f'''
module spregfile(
    input clk,
    input [{aw-1}:0] mem_addr,
    input [{dw-1}:0] mem_din,
    input ce_in,
    input we_in,
    input [{dw-1}:0] mem_wmask,
    output [{dw-1}:0] mem_dout
);
    la_spregfile_impl #(
        .AW({aw}),
        .DW({dw})
    ) memory (
        .clk(clk),
        .ce(ce_in),
        .we(we_in),
        .wmask(mem_wmask),
        .addr(mem_addr),
        .din(mem_din),
        .dout(mem_dout),
        .selctrl(1'b0),
        .ctrl(32'h0),
        .status()
    );
endmodule
'''
    return _generate


@pytest.fixture
def tdpram_macro():
    """Fixture to generate TDPRAM macro module content."""
    def _generate(aw, dw):
        return f'''
module tdpram(
    input clk_a,
    input ce_a,
    input we_a,
    input [{dw-1}:0] wmask_a,
    input [{aw-1}:0] addr_a,
    input [{dw-1}:0] din_a,
    output [{dw-1}:0] dout_a,
    input clk_b,
    input ce_b,
    input we_b,
    input [{dw-1}:0] wmask_b,
    input [{aw-1}:0] addr_b,
    input [{dw-1}:0] din_b,
    output [{dw-1}:0] dout_b
);
    la_tdpram_impl #(
        .AW({aw}),
        .DW({dw})
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
        .dout_b(dout_b),
        .selctrl(1'b0),
        .ctrl(32'h0),
        .status()
    );
endmodule
'''
    return _generate
