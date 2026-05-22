/******************************************************************************
 * Function: Parametrized N-input clock mux
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 * ****************************************************************************
 *
 * This a vectorized N input clock mux that allows for safe glitch-less
 * selection of an arbitrary number of input clocks. The circuit is
 * guaranteed glitch free given the following usage constraints:
 *
 * 1. Sel signals are one hot.
 *
 * 2. Two sel bits cannot be changed simultaneously, there must be a
 *    a puse with sel==0 between the dessertion of one clock select bit
 *    and the assertion of another clock select bit.
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

   wire [N-1:0] clken;
   wire [N-1:0] gatedclk;
   wire [N-1:0] nreset_sync;

   genvar i;

   for (i = 0; i < N; i = i + 1) begin : imux

      // Syncrhonize reset to each clock individually.
      la_rsync #(.STAGES(STAGES),
                 .PROP(PROP))
      irsync (.clk(clkin[i]),
              .nrst_in(nreset),
              .nrst_out(nreset_sync[i]));

      // Synchronize select to each clock individually
      la_drsync #(.STAGES(STAGES),
                  .PROP(PROP))
      idsync (.clk(clkin[i]),
              .nreset(nreset_sync[i]),
              .in(sel[i]),
              .out(clken[i]));

      // Gate each clock separately
      la_clkicgand #(.PROP(PROP))
      igate (.clk(clkin[i]),
             .en(clken[i]),
             .te(1'b0),
             .eclk(gatedclk[i]));
   end

   // Safe or tree of all clocks
   assign clkout = |gatedclk;

endmodule
