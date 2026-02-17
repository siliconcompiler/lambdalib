//#############################################################################
//# Function: Clock divider                                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkdiv2 #(parameter PROP = "DEFAULT" // cell property
                    )
   (
    input  clkin,  // fast input clock
    input  nreset, // async active low reset
    output clk,    // div2 clock
    output clk90   // div2 clock with 90 degree phase shift
    );

   wire clk90n;


   la_dffrq iclk (.clk(clkin),
                  .nreset(nreset),
                  .d(clk90n),
                  .q(clk));

   la_dffrq iclk90 (.clk(clkin),
                    .nreset(nreset),
                    .d(clk),
                    .q(clk90));

   la_inv iinv (.a(clk90),
                .z(clk90n));


endmodule
