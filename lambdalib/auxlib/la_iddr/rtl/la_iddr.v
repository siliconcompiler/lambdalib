//#############################################################################
//# Function: Dual data rate input buffer                                     #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
//
// Supports the following operating modes
// 0 - bypass
// 1 - oppositive-edge (sampling on fall and rise edge)
// 2 - same-edge (samples falling edge data with posedge of clock)
// 3 - pipeline-same edge (presents rise/fall edge data on same cycle)
//
// NOTE: hold latch used for negedge sampling in place of negedge sampling
//       to improve dity cycle resilence.
//
// Requirements:
// input data is valid "setup" time before and "hold time" after rising edge
// input data is valid
//
//#############################################################################

module la_iddr #(parameter PROP = "LATCH"
                 )
   (
    input       clk,     // clock
    input [1:0] mode,    // operating modes
    input       in,      // data input sampled on both edges of clock
    output      outrise, // rising edge sample
    output      outfall  // falling edge sample
    );

   reg r_edge_q;       // Rising edge capture
   reg f_edge_q;       // Fall edge sample
   reg f_edge_aligned; // Falling edge data moved to rising edge
   reg pipe_r, pipe_f; // Pipeline registers

   // Posedge sample
   always @(posedge clk)
     r_edge_q <= in;

   // Negedge sample
   always @(negedge clk)
     f_edge_q <= in;

   // Alignment logic
   always @(posedge clk)
     f_edge_aligned <= f_edge_q;

   // Pipeline
   always @(posedge clk) begin
      pipe_r <= r_edge_q;
      pipe_f <= f_edge_aligned;
   end

   // Mode selection
   assign outrise = (mode==1) ? r_edge_q        :
                    (mode==2) ? r_edge_aligned  :
                    (mode==3) ? pipe_r          :
                                in;

   assign outfall = (mode==1) ? f_edge_q       : // "Opposite"
                    (mode==2) ? f_edge_aligned : // "Same-Edge" (Aligned)
                    (mode==3) ? pipe_f         : // pipelined
                                1'b0;

endmodule
