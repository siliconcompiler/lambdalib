//#############################################################################
//# Function: Dual data rate input buffer                                     #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
//
// Supports the following operating modes
// 0 - bypass
// 1 - oppositive-edge
// 2 - same-edge
// 3 - pipeline-same edge
//
// NOTE: hold latch used for negedge sampling in place of negedge sampling
//       to improve dity cycle resilence.
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

   // Posedge clk sample
    always @(posedge clk)
      r_edge_q <= in;

   // Latch hold circuit (smaller, faster operation)
   generate
      if (PROP == "LATCH") begin: g_latch
`ifdef VERILATOR
         // Verilator: Use negedge FF to mimic latch behavior
         always @(negedge clk) begin
            f_edge_q <= in;
         end
`else
         // ASIC: Use the actual latch hold circuit
         always @(clk or in) begin
            if (!clk)
              f_edge_q <= in;
         end
`endif
      end
      else begin: g_ff
         always @(negedge clk)
           f_edge_q <= in;
      end
   endgenerate

   // Alignment logic
   always @(posedge clk)
     f_edge_aligned <= f_edge_q;

   // Pipeline
   always @(posedge clk) begin
      pipe_r <= r_edge_q;
      pipe_f <= f_edge_aligned;
   end

   // Mode selection
   assign outrise = (mode==0) ? in :
                    (mode==3) ? pipe_r : r_edge_q;

   assign outfall = (mode==0) ? 1'b0 :           // "Bypass"
                    (mode==1) ? f_edge_q :       // "Opposite"
                    (mode==2) ? f_edge_aligned : // "Same-Edge" (Aligned)
                    (mode==3) ? pipe_f : 1'b0;   // "Pipelined"

endmodule
