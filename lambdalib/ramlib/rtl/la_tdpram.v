/*****************************************************************************
 * Function: 
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a wrapper for selecting from a set of hardened memory macros.
 *
 * A synthesizable reference model is used when the PROP is DEFAULT. The
 * synthesizable model does not implement the cfg and test interface and should
 * only be used for basic testing and for synthesizing for FPGA devices.
 * Advanced ASIC development should rely on complete functional models
 * supplied on a per macro basis.
 *
 * Technology specific implementations of "la_tdpram" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP" to select between the list of modules
 * at build time.
 *
 ****************************************************************************/

module la_tdpram #(
    parameter DW    = 32,         // Memory width
    parameter AW    = 10,         // address width (derived)
    parameter PROP  = "DEFAULT",  // pass through variable for hard macro
    parameter CTRLW = 128,        // width of asic ctrl interface
    parameter TESTW = 128         // width of asic test interface
) (  // A port
    input             clk_a,      // write clock
    input             ce_a,       // write chip-enable
    input             we_a,       // write enable
    input [DW-1:0]    wmask_a,    // write mask
    input [AW-1:0]    addr_a,     // write address
    input [DW-1:0]    din_a,      // write data in
    output [DW-1:0]   dout_a,     // read data out
    // B port
    input             clk_b,      // write clock
    input             ce_b,       // write chip-enable
    input             we_b,       // write enable
    input [DW-1:0]    wmask_b,    // write mask
    input [AW-1:0]    addr_b,     // write address
    input [DW-1:0]    din_b,      // write data in
    output [DW-1:0]   dout_b,     // read data out
    // Power signal
    input             vss,        // ground signal
    input             vdd,        // memory core array power
    input             vddio,      // periphery/io power
    // Generic interfaces
    input [CTRLW-1:0] ctrl,       // pass through ASIC control interface
    input [TESTW-1:0] test        // pass through ASIC test interface
);

    la_tdpram_impl #(
        .DW         (DW),
        .AW         (AW),
        .PROP       (PROP),
        .CTRLW      (CTRLW),
        .TESTW      (TESTW)
    ) memory (
        .clk_a      (clk_a),
        .ce_a       (ce_a),
        .we_a       (we_a),
        .wmask_a    (wmask_a),
        .addr_a     (addr_a),
        .din_a      (din_a),
        .dout_a     (dout_a),
        
        .clk_b      (clk_b),
        .ce_b       (ce_b),
        .we_b       (we_b),
        .wmask_b    (wmask_b),
        .addr_b     (addr_b),
        .din_b      (din_b),
        .dout_b     (dout_b),
        
        .vss        (vss),
        .vdd        (vdd),
        .vddio      (vddio),
        
        .ctrl       (ctrl),
        .test       (test)
    );

endmodule
