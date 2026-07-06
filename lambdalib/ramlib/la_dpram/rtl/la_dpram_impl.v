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
                       parameter AW = 10,          // address width
                       parameter BYTEMASK = 0,     // 1=byte mask, 0=bit mask
                       parameter PROP = "DEFAULT", // variable for hard macro
                       parameter CTRLW = 32,       // width of ctrl interface
                       parameter STATUSW = 32      // width of status interface
                       )
   (// Write port
    input               wr_clk,   // write clock
    input               wr_ce,    // write chip-enable
    input               wr_we,    // write enable
    input [(BYTEMASK ? DW/8 : DW)-1:0] wr_wmask, // bit or byte write mask
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

   // Byte mode delivers a DW/8-wide mask (one bit per byte); replicate each
   // mask bit across its 8-bit lane to form a byte-uniform DW-wide mask for
   // the reference model. Bit mode passes the per-bit mask through.
   wire [DW-1:0] wr_wmask_int;
   genvar gwm;
   generate
      if (BYTEMASK) begin : g_wm_byte
         for (gwm = 0; gwm < DW/8; gwm = gwm + 1) begin : g_wm_lane
            assign wr_wmask_int[gwm*8+:8] = {8{wr_wmask[gwm]}};
         end
      end
      else begin : g_wm_bit
         assign wr_wmask_int = wr_wmask;
      end
   endgenerate

`ifdef VERILATOR
   // Fast equivalent ram write model (for ultra wide RAMs)
   always @(posedge wr_clk)
     if (wr_ce & wr_we)
       ram[wr_addr[AW-1:0]] <= (wr_din[DW-1:0]       &  wr_wmask_int[DW-1:0]) |
                               (ram[wr_addr[AW-1:0]] & ~wr_wmask_int[DW-1:0]);
`else
   // FPGA synthesis friendly RAM pattern. BYTEMASK selects the write
   // granularity: per-bit (hard macro) or per 8-bit lane (byte-wide BRAM).
   // In byte mode wr_wmask_int is byte-uniform (replicated above) and DW
   // must be a multiple of 8.
   generate
      if (BYTEMASK) begin : g_bytemask
         integer i;
         always @(posedge wr_clk)
           if (wr_ce & wr_we)
             for (i = 0; i < DW/8; i = i + 1)
               if (wr_wmask_int[i*8])
                 ram[wr_addr[AW-1:0]][i*8+:8] <= wr_din[i*8+:8];
      end
      else begin : g_bitmask
         integer i;
         always @(posedge wr_clk)
           if (wr_ce & wr_we)
             for (i = 0; i < DW; i = i + 1)
               if (wr_wmask_int[i])
                 ram[wr_addr[AW-1:0]][i] <= wr_din[i];
      end
   endgenerate
`endif

   // Read Port
   always @(posedge rd_clk) if (rd_ce) rd_dout[DW-1:0] <= ram[rd_addr[AW-1:0]];

   // Status (active in hard macro, tied off in soft model)
   assign status = {STATUSW{1'b0}};

endmodule
