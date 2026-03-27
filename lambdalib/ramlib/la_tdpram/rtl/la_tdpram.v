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

module la_tdpram #(parameter DW = 32,          // Memory width
                   parameter AW = 10,          // Address width (derived)
                   parameter PROP = "DEFAULT", // variable for hard macro
                   parameter CTRLW = 32,       // width of ctrl interface
                   parameter STATUSW = 32      // width of status interface
                   )
   (// A port
    input               clk_a,   // write clock
    input               ce_a,    // write chip-enable
    input               we_a,    // write enable
    input [DW-1:0]      wmask_a, // write mask
    input [AW-1:0]      addr_a,  // write address
    input [DW-1:0]      din_a,   // write data in
    output [DW-1:0]     dout_a,  // read data out
    // B port
    input               clk_b,   // write clock
    input               ce_b,    // write chip-enable
    input               we_b,    // write enable
    input [DW-1:0]      wmask_b, // write mask
    input [AW-1:0]      addr_b,  // write address
    input [DW-1:0]      din_b,   // write data in
    output [DW-1:0]     dout_b,  // read data out
    // Technology interfaces
    input               selctrl, // selects control interface
    input [CTRLW-1:0]   ctrl,    // pass through control interface
    input [STATUSW-1:0] status   // pass through status interface
    );

   la_tdpram_impl #(.DW      (DW),
                    .AW      (AW),
                    .PROP    (PROP),
                    .CTRLW   (CTRLW),
                    .STATUSW (STATUSW))
   memory (// a port
           .clk_a      (clk_a),
           .ce_a       (ce_a),
           .we_a       (we_a),
           .wmask_a    (wmask_a),
           .addr_a     (addr_a),
           .din_a      (din_a),
           .dout_a     (dout_a),
           // b port
           .clk_b      (clk_b),
           .ce_b       (ce_b),
           .we_b       (we_b),
           .wmask_b    (wmask_b),
           .addr_b     (addr_b),
           .din_b      (din_b),
           .dout_b     (dout_b),
            // macro interface
           .selctrl    (selctrl),
           .ctrl       (ctrl),
           .status     (status));

endmodule
