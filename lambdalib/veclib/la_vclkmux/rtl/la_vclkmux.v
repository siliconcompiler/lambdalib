/******************************************************************************
 * Function: Parametrized N-input clock mux
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 * ****************************************************************************
 *
 * This a vectorized N input clock mux that allows for safe glitch-less
 * selection of an arbitrary number of input clocks using asynchronous
 * inputs 'nreset' and 'sel'. The circuit is safe as long as the following
 * sequence is followed:
 *
 * 1. Assert async reset (nreset==0), usually by setting a bit in a register
 * (ie CLKEN=0).
 *
 * 2. Change the async 'sel' value, usually by changing a register like 'CLKSEL'.
 *
 * 3. Deassert async reset (nreset==1) to reneable clkout.
 *
 *******************************************************************************/

module la_vclkmux
  #(parameter N = 1,           // number clock inputs
    parameter STAGES = 2,      // sync stages
    parameter PROP = "DEFAULT" // cell property
    )
   (
    input [N-1:0] clkin,  // clock inputs
    input         nreset, // async nreset (clears output clock)
    input [N-1:0] sel,    // one hot async clock selector
    output        clkout  // gated clock output
    );

   wire [N-1:0] clk;
   wire [N-1:0] clken;
   wire [N-1:0] gatedclk;

   genvar i;

   for (i = 0; i < N; i = i + 1) begin : isync

      // 1. Asynchronous Reset, Synchronous Release if reset
      // 2. Non-glitching guaranteed via nreset sequence
      la_drsync isync (.clk(clkin[i]),
                       .nreset(nreset),
                       .in(sel[i]),
                       .out(clken[i]));

      // Gate each clock separately
      la_clkicgand iicg (.clk(clkin[i]),
                         .en(clken[i]),
                         .te(1'b0),
                         .eclk(gatedclk[i]));
   end

   // Safe or tree of all clocks
   assign clkout = |gatedclk;

endmodule
