//#############################################################################
//# Function: Vectorized negative edge-triggered static D-type flop-flop      #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_vdffnq #(parameter W = 1,    // width of mux
                   parameter PROP = "" // cell property
                   )
   (
    input [W-1:0]      d,
    input              clk,
    output reg [W-1:0] q
    );

   always @(negedge clk)
     q <= d;

endmodule
