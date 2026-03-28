/*****************************************************************************
 * Function: Dual Port RAM (One write port + One read port)
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
 * Technology specific implementations of "la_dpram" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP" to select between the list of modules
 * at build time.
 *
 ****************************************************************************/

module la_dpram_impl #(
                       parameter DW = 32,          // memory width
                       parameter AW = 10,          // address width (derived)
                       parameter PROP = "DEFAULT", // variable for hard macro
                       parameter CTRLW = 32,       // width of ctrl interface
                       parameter STATUSW = 32      // width of status interface
                       )
   (// Write port
    input               wr_clk,   // write clock
    input               wr_ce,    // write chip-enable
    input               wr_we,    // write enable
    input [DW-1:0]      wr_wmask, // write mask
    input [AW-1:0]      wr_addr,  // write address
    input [DW-1:0]      wr_din,   //write data in
    // Read port
    input               rd_clk,   // read clock
    input               rd_ce,    // read chip-enable
    input [AW-1:0]      rd_addr,  // read address
    output reg [DW-1:0] rd_dout,  //read data out
    // Technology interfaces
    input               selctrl,  // selects control interface
    input [CTRLW-1:0]   ctrl,     // pass through control interface
    output [STATUSW-1:0] status    // pass through status interface
    );

   // Generic RTL RAM
   reg     [DW-1:0] ram[(2**AW)-1:0];
   integer          i;

   // Write port
   always @(posedge wr_clk)
     for (i = 0; i < DW; i = i + 1)
       if (wr_ce & wr_we & wr_wmask[i]) ram[wr_addr[AW-1:0]][i] <= wr_din[i];

   // Read Port
   always @(posedge rd_clk) if (rd_ce) rd_dout[DW-1:0] <= ram[rd_addr[AW-1:0]];

endmodule
