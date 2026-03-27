/*****************************************************************************
 * Function: Single Port Register File
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
 * Technology specific implementations of "la_spregfile" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP" to select between the list of modules
 * at build time.
 *
 ****************************************************************************/

module la_spregfile_impl #(parameter DW = 32,          // Memory width
                           parameter AW = 10,          // Address width (derived)
                           parameter PROP = "DEFAULT", // variable for hard macro
                           parameter CTRLW = 32,       // width of ctrl interface
                           parameter STATUSW = 32      // width of status interface
                           )
   (// Memory interface
    input               clk,     // write clock
    input               ce,      // chip enable
    input               we,      // write enable
    input [DW-1:0]      wmask,   // per bit write mask
    input [AW-1:0]      addr,    // write address
    input [DW-1:0]      din,     // write data
    output reg [DW-1:0] dout,    // read output data
    // Technology interfaces
    input               selctrl, // selects control interface
    input [CTRLW-1:0]   ctrl,    // pass through control interface
    input [STATUSW-1:0] status   // pass through status interface
    );

    // Generic RTL RAM
   reg     [DW-1:0] ram[(2**AW)-1:0];

    // Write port
    //   always @(posedge clk)
    //     for (i=0;i<DW;i=i+1)
    //       if (ce & we & wmask[i])
    //         ram[addr[AW-1:0]][i] <= din[i];

    // Re-writing as a mux for verilator
    always @(posedge clk)
      if (ce & we)
        ram[addr[AW-1:0]] <= (din[DW-1:0] & wmask[DW-1:0]) |
                             (ram[addr[AW-1:0]] & ~wmask[DW-1:0]);

    // Read Port
    always @(posedge clk)
      if (ce)
        dout[DW-1:0] <= ram[addr[AW-1:0]];

endmodule
