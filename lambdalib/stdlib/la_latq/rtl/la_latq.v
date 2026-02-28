//#############################################################################
//# Function:  D-type active-high transparent latch                           #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:   MIT (see LICENSE file in Lambda repository)                    #
//#############################################################################

module la_latq #(
    parameter PROP = "DEFAULT"
) (
    input      d,
    input      clk,
    output reg q
);

`ifdef VERILATOR
    always @(posedge clk) q <= d;
`else
    always @(clk or d) if (clk) q <= d;
`endif

endmodule
