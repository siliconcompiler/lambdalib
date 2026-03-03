//#############################################################################
//# Function:  Vectorized D-type active-high transparent latch                #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:   MIT (see LICENSE file in Lambda repository)                    #
//#############################################################################

module la_vlatq #(parameter W = 1,    // width of mux
                  parameter PROP = "" // cell property
                  )
   (
    input [W-1:0]      d,
    input              clk,
    output reg [W-1:0] q
    );

`ifdef VERILATOR
   always @(posedge clk) q <= d;
`else
   always @(clk or d)
     if (clk)
       q <= d;
`endif

endmodule
