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
   /* We model the latch as a posedge flip-flop sampling on the opening
    * edge of the latch enable*/

   initial
     $display("WARNING: Reduced order model used for la_latq for verilator. A fully functional Verilog simulator must be used for chip signoff.");

   always @(posedge clk) q <= d;

`else
    always @(clk or d) if (clk) q <= d;
`endif

endmodule
