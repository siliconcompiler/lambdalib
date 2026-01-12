//#############################################################################
//# Function: Dual data rate input buffer                                     #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
//
// Supports the following operating modes
// 0 - bypass
// 1 - sample (capture input on fall and rise edge of clk)
// 2 - align (falling edge data aligned to posedge of clk)
// 3 - pipe (align rise/fall edge data on same clk cycle)
//
// NOTE:
// - input clock is forward-shifted so that posedge capture qrise first
// - See docs/iddr_waveform.json for waveform description
//
//#############################################################################

module la_iddr #(parameter PROP = ""
                 )
   (
    input       clk,   // clock
    input       in,    // dual data rate input
    input [1:0] mode,  // operating modes
    output      qrise, // rising edge sample
    output      qfall  // falling edge sample
    );

   reg r_edge_q;       // Rising edge capture
   reg f_edge_q;       // Falling edge capture
   reg f_edge_aligned; // Falling edge data moved to rising edge
   reg r_edge_aligned; // Rising edge data pipeline for mode 3

   // Sample
   always @(posedge clk)
     r_edge_q <= in;

   // Negedge sample
   always @(negedge clk)
     f_edge_q <= in;

   // Alignment logic
   always @(posedge clk)
     begin
        r_edge_aligned <= r_edge_q; // pipe mode only
        f_edge_aligned <= f_edge_q; // resample negedge locally
     end

   // Mode selection
   assign qrise = (mode==1) ? r_edge_q        :
                  (mode==2) ? r_edge_q        :
                  (mode==3) ? r_edge_aligned  :
                              in;

   assign qfall = (mode==1) ? f_edge_q       : // raw sample
                  (mode==2) ? f_edge_aligned : // aligned
                  (mode==3) ? f_edge_aligned : // pipelined
                              1'b0;

endmodule
