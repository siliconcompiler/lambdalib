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

   wire clknext;
   wire clkinbar;

   // 50% duty cycle divide by 2 johnson counter
   la_inv iinvfb (.a(clk), .z(clknext));

   la_dffrq idff (.clk(clkin),
                  .nreset(nreset),
                  .d(clknext),
                  .q(clk));


   // We sample the "Master" clock (clk) using the falling edge.
   // This guarantees clk90 transitions exactly 1/2 clkin cycle later.
   // latency from clkin to clk is one flop
   // latency from clkin to clk90 is one flop+inv

   la_inv iinvclkin (.a(clkin), .z(clkinbar));

   la_dffrq idff90 (.clk(clkinbar),
                    .nreset(nreset),
                    .d(clk),
                    .q(clk90));

endmodule
