//#############################################################################
//# Function: Dual data rate output buffer                                    #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
//
// Supports the following operating modes
// 0 - bypass
// 1 - oppositive-edge
// 2 - same-edge
// 3 - n/a
//
// NOTE: hold latch used for negedge sampling in place of negedge sampling
//       to improve dity cycle resilence.
//
//#############################################################################

module la_oddr #(parameter PROP = "LATCH"
                 )
   (
    input       clk,  // clock input
    input [1:0] mode, // operating modes
    input       in0,  // data for rising edge
    input       in1,  // data for falling edge
    output      out   // dual data rate output
    );

   //###################################
   // Declarations
   //###################################

   reg  q0;            // Sampled rising edge data
   reg  q1_low;        // For Mode 1 (Opposite-Edge)
   reg  q1_high;       // For Mode 2 (Same-Edge)
   wire q1_sh;         // Final ddata for negedge
   wire ddr;           // Dual data rate (pre bypass mux)

   //###################################
   // Primary Capture (Latch or FF)
   //###################################

   always @(posedge clk)
     q0 <= in0;

   //###################################
   // Secondary Capture (Latch or FF)
   //###################################

   generate
      if (PROP == "LATCH") begin : g_latch
`ifdef VERILATOR
         // In Verilator, we mimic the latch behavior with FFs
         wire clk_sample = (mode == 1) ? !clk : clk;
         reg  q1_sim;
         always @(posedge clk_sample)
           q1_sim <= in1;
         assign q1_sh = q1_sim;
`else
         always @(clk or in1) if (clk)  q1_high <= in1; // high latch
         always @(clk or in1) if (!clk) q1_low  <= in1; // low latch
         assign q1_sh = (mode == 1) ? q1_low : q1_high; // edge/mode selector
`endif
      end else begin : g_ff
         always @(posedge clk) q1_high <= in1;
         always @(negedge clk) q1_low  <= in1;
         assign q1_sh = (mode == 1) ? q1_low : q1_high;
      end
   endgenerate

   //###################################
   // Output muxing
   //###################################

   assign ddr = clk ? q0 : q1_sh;
   assign out = (mode == 0) ? in0 : ddr;

endmodule
