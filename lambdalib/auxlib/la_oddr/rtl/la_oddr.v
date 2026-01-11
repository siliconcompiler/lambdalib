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

   // Internal Signals
   reg q0;        // Captures in0 on Rising Edge
   reg q1_sh;     // Alignment/Shift register for in1
   wire ddr;

   // Capture Rising Edge
   always @(posedge clk)
     q0 <= in0;

   // Mode 1 (Opposite Edge): Internal logic provides in1 with setup before
   // falling edge.
   // Mode 2 (Same Edge): Internal logic provides in1 on rising edge;
   // we must delay it.

   generate
      if (PROP == "LATCH") begin : g_latch
`ifdef VERILATOR
         always @(posedge clk)
           q1_sh <= in1;
`else
         always @(clk or in1)
           if (clk)
             q1_sh <= in1;

`endif
      end else begin : g_ff
         // Standard Approach: Capture in1 on falling edge.
         always @(negedge clk)
           q1_sh <= in1;
      end
   endgenerate

   // Output Multiplexing ---
   assign ddr = clk ? q0 : q1_sh;
   assign out = (mode == 0) ? in0 : ddr;

endmodule
