//#############################################################################
//# Function: Integrated "And" Clock Gating Cell (And)                        #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkicgand #(
    parameter PROP = "DEFAULT"
) (
    input  clk,  // clock input
    input  te,   // test enable
    input  en,   // enable (from positive edge FF)
    output eclk  // enabled clock output
);

    reg en_stable;

`ifdef VERILATOR
   // Edge-triggered model instead of a latch (verilator safe)
   always @(negedge clk) begin
      en_stable <= en | te;
   end
`else
   // Synthesis: (ASIC-style transparent latch)
   always @(clk or en or te) begin
      if (~clk)
        en_stable <= en | te;
   end
`endif

    assign eclk = clk & en_stable;

endmodule
