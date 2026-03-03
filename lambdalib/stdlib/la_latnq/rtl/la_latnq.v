//#############################################################################
//# Function:  D-type active-low transparent latch                            #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:   MIT (see LICENSE file in Lambda repository)                    #
//#############################################################################

module la_latnq #(
    parameter PROP = "DEFAULT"
) (
    input      d,
    input      clk,
    output reg q
);

`ifdef VERILATOR
   /* We model the latch as a negedge flip-flop sampling on the opening
    * edge of the latch enable*/
  initial
    $display("WARNING: Reduced order verilator safe model used for la_latnq.");

   always @(negedge clk) q <= d;
`else
    always @(clk or d) if (~clk) q <= d;
`endif

endmodule
