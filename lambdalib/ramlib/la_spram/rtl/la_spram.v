/*****************************************************************************
 * Function: Single Port RAM
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
 * Technologoy specific implementations of "la_spram" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP" to select between the list of modules
 * at build time.
 *
 ****************************************************************************/

module la_spram #(
    parameter DW    = 32,         // Memory width
    parameter AW    = 10,         // Address width (derived)
    parameter PROP  = "DEFAULT",  // Pass through variable for hard macro
    parameter CTRLW = 1,          // Width of asic ctrl interface
    parameter TESTW = 1           // Width of asic test interface
) (  // Memory interface
    input             clk,   // write clock
    input             ce,    // chip enable
    input             we,    // write enable
    input [DW-1:0]    wmask, //per bit write mask
    input [AW-1:0]    addr,  //write address
    input [DW-1:0]    din,   //write data
    output [DW-1:0]   dout,  //read output data
    // Power signals
    input             vss,   // ground signal
    input             vdd,   // memory core array power
    input             vddio, // periphery/io power
    // Generic interfaces
    input [CTRLW-1:0] ctrl,  // pass through ASIC control interface
    input [TESTW-1:0] test   // pass through ASIC test interface
);

    la_spram_impl #(
        .DW     (DW),
        .AW     (AW),
        .PROP   (PROP),
        .CTRLW  (CTRLW),
        .TESTW  (TESTW)
    ) memory (
        .clk    (clk),
        .ce     (ce),
        .we     (we),
        .wmask  (wmask),
        .addr   (addr),
        .din    (din),
        .dout   (dout),

        .vss    (vss),
        .vdd    (vdd),
        .vddio  (vddio),

        .ctrl   (ctrl),
        .test   (test)
    );

endmodule
