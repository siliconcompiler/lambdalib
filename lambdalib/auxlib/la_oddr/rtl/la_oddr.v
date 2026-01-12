//#############################################################################
//# Function: Dual data rate output buffer                                    #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
//
// Supports the following operating modes
// 0 - bypass
// 1 - sample (negedge data arrieves before posedge data, experimental)
// 2 - align (standard, in0, in1 arrives at same clock cycle)
// 3 - n/a
//
// NOTE:
// - external to this block, a forward-shifted clock must be provided that
//   is forward shifted by 90 degrees from this clock
// - See docs/oiddr_waveform.json for waveform description
//
//#############################################################################

module la_oddr #(parameter PROP = ""
                 )
   (
    input       clk,  // clock input
    input [1:0] mode, // operating modes
    input       in0,  // data for rising edge
    input       in1,  // data for falling edge
    output      q     // dual data rate output
    );

   reg  q0;            // Sampled rising edge data
   reg  q1;            // Alignment for negedge
   reg  q1_negedge;    // Negedge data
   wire ddr;           // Dual data rate (pre bypass mux)

   // sampling inputs
   always @(posedge clk)
     begin
        q0 <= in0;
        q1 <= in1;
     end

   // mode based negedge sample
   always @(negedge clk)
     q1_negedge <= (mode == 2) ? q1 : in1;

   // use clk as mux select
   assign ddr = clk ? q0 : q1_negedge;

   // fast async bypass
   assign q = (mode == 0) ? in0 : ddr;

endmodule
