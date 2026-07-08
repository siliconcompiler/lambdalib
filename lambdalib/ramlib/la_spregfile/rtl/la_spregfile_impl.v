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
                           parameter BYTEMASK = 0,     // 1=byte mask, 0=bit mask
                           parameter PROP = "DEFAULT", // variable for hard macro
                           parameter CTRLW = 32,       // width of ctrl interface
                           parameter STATUSW = 32      // width of status interface
                           )
   (// Memory interface
    input                          clk,     // write clock
    input                          ce,      // chip enable
    input                          we,      // write enable
    input [(BYTEMASK?DW/8:DW)-1:0] wmask,   // bit or byte write mask
    input [AW-1:0]                 addr,    // write address
    input [DW-1:0]                 din,     // write data
    output reg [DW-1:0]            dout,    // read output data
    // Technology interfaces
    input               selctrl, // selects control interface
    input [CTRLW-1:0]   ctrl,    // pass through control interface
    output [STATUSW-1:0] status   // pass through status interface
    );

    // Generic RTL RAM
   reg     [DW-1:0] ram[(2**AW)-1:0];

`ifdef VERILATOR
    // Fast equivalent ram write model (for ultra wide RAMs). The vectorized
    // AND/OR needs a full DW-wide bit mask, so byte mode replicates each mask
    // bit across its 8-bit lane; bit mode passes the per-bit mask through.
    wire [DW-1:0] wmask_int;
    genvar gwm;
    generate
      if (BYTEMASK) begin : g_wm_byte
         for (gwm = 0; gwm < DW/8; gwm = gwm + 1) begin : g_wm_lane
            assign wmask_int[gwm*8+:8] = {8{wmask[gwm]}};
         end
      end
      else begin : g_wm_bit
         assign wmask_int = wmask;
      end
    endgenerate

    always @(posedge clk)
      if (ce & we)
        ram[addr[AW-1:0]] <= (din[DW-1:0]       &  wmask_int[DW-1:0]) |
                             (ram[addr[AW-1:0]] & ~wmask_int[DW-1:0]);
`else
    // FPGA synthesis friendly RAM pattern. BYTEMASK selects the write
    // granularity: per 8-bit lane (byte-wide BRAM) or per-bit (hard macro).
    // In byte mode wmask is DW/8-wide and DW must be a multiple of 8.
    generate
      if (BYTEMASK) begin : g_bytemask
         integer i;
         always @(posedge clk)
           if (ce & we)
             for (i = 0; i < DW/8; i = i + 1)
               if (wmask[i])
                 ram[addr[AW-1:0]][i*8+:8] <= din[i*8+:8];
      end
      else begin : g_bitmask
         integer i;
         always @(posedge clk)
           if (ce & we)
             for (i = 0; i < DW; i = i + 1)
               if (wmask[i])
                 ram[addr[AW-1:0]][i] <= din[i];
      end
    endgenerate
`endif

    // Read Port
    always @(posedge clk)
      if (ce)
        dout[DW-1:0] <= ram[addr[AW-1:0]];

    // Status (active in hard macro, tied off in soft model)
    assign status = {STATUSW{1'b0}};

endmodule
