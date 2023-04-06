//#############################################################################
//# Function: 4-Input Glitch-Free Clock Mux                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkmux4
  #(parameter PROP = "DEFAULT"  // cell property
    )
   (
    input  clk0,
    input  clk1,
    input  clk2,
    input  clk3,
    input  sel0,
    input  sel1,
    input  sel2,
    input  sel3,
    output out
    );

   wire [3:0] mask;
   wire [3:0] maskb;
   wire [3:0] en;
   wire [3:0] ensync;
   wire [3:0] clkg;

   // create clock mask (4)
   la_or3 ior0 (.a(ensync[3]), .b(ensync[2]), .c(ensync[1]), .z(mask[0]));
   la_or3 ior1 (.a(ensync[0]), .b(ensync[3]), .c(ensync[2]), .z(mask[1]));
   la_or3 ior2 (.a(ensync[1]), .b(ensync[0]), .c(ensync[3]), .z(mask[2]));
   la_or3 ior3 (.a(ensync[2]), .b(ensync[1]), .c(ensync[0]), .z(mask[3]));

   // invert mask (4)
   la_inv iinv[3:0] (.a(mask[3:0]), .z(maskb[3:0]));

   // clock enable (4)
   la_and2 isel[3:0] (.a({sel3,sel2,sel1,sel0}),
		      .b(maskb[3:0]),
		      .z(en[3:0]));

   // synchronizers (4)
   la_dsync isync[3:0] (.clk({clk3,clk2,clk1,clk0}),
			.in(en[3:0]),
			.out(ensync[3:0]));

   // glith free clock gate (4)
   la_and2 igate[3:0] (.a({clk3,clk2,clk1,clk0}),
		       .b(ensync[3:0]),
		       .z(clkg[3:0]));

   // final clock or (1)
   la_or4 iorclk (.a(clkg[0]),
		  .b(clkg[1]),
		  .c(clkg[2]),
		  .d(clkg[3]),
		  .z(out));

endmodule // la_clkmux4