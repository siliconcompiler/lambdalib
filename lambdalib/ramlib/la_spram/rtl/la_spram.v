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
 * Technology specific implementations of "la_spram" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP", AW, and DW to select between the list of
 * modules at build time.
 *
 * The 'selctrl' signal tells the implementation to select the ctrl interface
 * if set to one, otherwise hard coded tech specific parameters inside the
 * lambdalib implementations are used to control the RAM.
 *
 ****************************************************************************/

module la_spram #(parameter DW = 32,          // Memory width
                  parameter AW = 10,          // Address width (derived)
                  parameter BYTEMODE = 0,     // 1=byte mask, 0=bit mask(def)
                  parameter PROP = "DEFAULT", // Variable for hard macro
                  parameter CTRLW = 32,       // width of ctrl interface
                  parameter STATUSW = 32      // width of status interface
                  )
   (// Memory interface
    input               clk,     // write clock
    input               ce,      // chip enable
    input               we,      // write enable
    input [DW-1:0]      wmask,   //per bit write mask
    input [AW-1:0]      addr,    //write address
    input [DW-1:0]      din,     //write data
    output [DW-1:0]     dout,    //read output data
    // Technology interfaces
    input               selctrl, // selects control interface
    input [CTRLW-1:0]   ctrl,    // pass through control interface
    output [STATUSW-1:0] status   // pass through status interface
    );

   // In byte mode replicate byte-aligned mask bit wmask[i*8] across its
   // 8-bit lane so the lane is byte-uniform. This keeps the synthesis byte
   // for-loop and the verilator mux consistent, and gives any hard macro a
   // clean byte mask. Bit mode passes the per-bit mask through.
   wire [DW-1:0] wmask_int;
   genvar gi;
   generate
      if (BYTEMODE)
        for (gi = 0; gi < DW/8; gi = gi + 1) begin : g_lane
           assign wmask_int[gi*8+:8] = {8{wmask[gi*8]}};
        end
      else
        assign wmask_int = wmask;
   endgenerate

   la_spram_impl #(.DW      (DW),
                   .AW      (AW),
                   .BYTEMODE(BYTEMODE),
                   .PROP    (PROP),
                   .CTRLW   (CTRLW),
                   .STATUSW (STATUSW))
   memory (// port
           .clk    (clk),
           .ce     (ce),
           .we     (we),
           .wmask  (wmask_int),
           .addr   (addr),
           .din    (din),
           .dout   (dout),
           // macro interface
           .selctrl    (selctrl),
           .ctrl       (ctrl),
           .status     (status));

endmodule
