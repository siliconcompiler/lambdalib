//#############################################################################
//# Function: Integrated "Or" Clock Gating Cell                               #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkicgor #(
    parameter PROP = "DEFAULT"
) (
    input  clk,  // clock input
    input  te,   // test enable
    input  en,   // enable
    output eclk  // enabled clock output
);

    reg en_stable;

`ifdef VERILATOR
   // Posedge flop model instead of latch (verilator safe)
   always @(posedge clk) begin
      en_stable <= en | te;
   end
`else
   // Synthesis: preserve latch-on-high style
   always @(clk or en or te) begin
      if (clk)
        en_stable <= en | te;
   end
`endif

   assign eclk = clk | ~en_stable;

endmodule
