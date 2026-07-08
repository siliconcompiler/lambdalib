/*****************************************************************************
 * Function: True Dual Port RAM (Two write + read ports)
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

module la_tdpram_impl #(parameter DW = 32,          // memory width
                        parameter AW = 10,          // address width
                        parameter BYTEMASK = 0,     // 1=byte mask, 0=bit mask
                        parameter PROP = "DEFAULT", // variable for hard macro
                        parameter CTRLW = 32,       // width of ctrl interface
                        parameter STATUSW = 32      // width of status interface
                        )
   (// A port
    input                              clk_a,   // write clock
    input                              ce_a,    // write chip-enable
    input                              we_a,    // write enable
    input [(BYTEMASK?DW/8:DW)-1:0]     wmask_a, // bit or byte write mask
    input [AW-1:0]                     addr_a,  // write address
    input [DW-1:0]                     din_a,   // write data in
    output reg [DW-1:0]                dout_a,  // read data out
    // B port
    input                              clk_b,   // write clock
    input                              ce_b,    // write chip-enable
    input                              we_b,    // write enable
    input [(BYTEMASK ? DW/8 : DW)-1:0] wmask_b, // bit or byte write mask
    input [AW-1:0]                     addr_b,  // write address
    input [DW-1:0]                     din_b,   // write data in
    output reg [DW-1:0]                dout_b,  // read data out
    // Technology interfaces
    input                              selctrl, // selects control interface
    input [CTRLW-1:0]                  ctrl,    // control interface
    output [STATUSW-1:0]               status   // status interface
    );

   // Generic RTL RAM
   /* verilator lint_off MULTIDRIVEN */
   reg [DW-1:0]       ram[(2**AW)-1:0];
   /* verilator lint_on MULTIDRIVEN */

`ifdef VERILATOR
   // Fast equivalent ram write model (for ultra wide RAMs). The vectorized
   // AND/OR needs full DW-wide bit masks, so byte mode replicates each mask
   // bit across its 8-bit lane; bit mode passes the per-bit masks through.
   wire [DW-1:0] wmask_a_int;
   wire [DW-1:0] wmask_b_int;
   genvar gwm;
   generate
      if (BYTEMASK) begin : g_wm_byte
         for (gwm = 0; gwm < DW/8; gwm = gwm + 1) begin : g_wm_lane
            assign wmask_a_int[gwm*8+:8] = {8{wmask_a[gwm]}};
            assign wmask_b_int[gwm*8+:8] = {8{wmask_b[gwm]}};
         end
      end
      else begin : g_wm_bit
         assign wmask_a_int = wmask_a;
         assign wmask_b_int = wmask_b;
      end
   endgenerate

   always @(posedge clk_a)
     if (ce_a & we_a)
       ram[addr_a] <= (din_a & wmask_a_int) | (ram[addr_a] & ~wmask_a_int);
   always @(posedge clk_b)
     if (ce_b & we_b)
       ram[addr_b] <= (din_b & wmask_b_int) | (ram[addr_b] & ~wmask_b_int);
`else
   // FPGA synthesis friendly RAM pattern. BYTEMASK selects the write
   // granularity: per 8-bit lane (byte-wide BRAM) or per-bit (hard macro).
   // In byte mode the masks are DW/8-wide and DW must be a multiple of 8.

   // Port A write
   generate
      if (BYTEMASK) begin : g_bytemask_a
         integer i;
         always @(posedge clk_a)
           if (ce_a & we_a)
             for (i = 0; i < DW/8; i = i + 1)
               if (wmask_a[i])
                 ram[addr_a][i*8+:8] <= din_a[i*8+:8];
      end
      else begin : g_bitmask_a
         integer i;
         always @(posedge clk_a)
           if (ce_a & we_a)
             for (i = 0; i < DW; i = i + 1)
               if (wmask_a[i])
                 ram[addr_a][i] <= din_a[i];
      end
   endgenerate

   // Port B write
   generate
      if (BYTEMASK) begin : g_bytemask_b
         integer i;
         always @(posedge clk_b)
           if (ce_b & we_b)
             for (i = 0; i < DW/8; i = i + 1)
               if (wmask_b[i])
                 ram[addr_b][i*8+:8] <= din_b[i*8+:8];
      end
      else begin : g_bitmask_b
         integer i;
         always @(posedge clk_b)
           if (ce_b & we_b)
             for (i = 0; i < DW; i = i + 1)
               if (wmask_b[i])
                 ram[addr_b][i] <= din_b[i];
      end
   endgenerate
`endif

   // Port A read
   always @(posedge clk_a) begin
      if (ce_a && ~we_a) begin
         dout_a <= ram[addr_a];
      end
   end

   // Port B read
   always @(posedge clk_b) begin
      if (ce_b && ~we_b) begin
         dout_b <= ram[addr_b];
      end
   end

   // Status (active in hard macro, tied off in soft model)
   assign status = {STATUSW{1'b0}};

endmodule
