//#############################################################################
//# Function: 2-Input Glitch-Free Clock Mux                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkmux2 #(parameter PROP = "DEFAULT" // cell property
                    )
   (
    input  clk0,
    input  clk1,
    input  sel, // 1=clk1, 0=clk0
    output out
    );

`ifdef VERILATOR
   // Dual-edge register breaks combinational clk→out dependency.
   // In real silicon, the glitch-free clock mux uses ICG standard cells
   // with no combinational clock-to-output path in static timing analysis.
   reg out_reg;
   always @(posedge clk0 or negedge clk0 or posedge clk1 or negedge clk1)
     out_reg <= sel ? clk1 : clk0;
   assign out = out_reg;
`else
   // local wires
   wire       selb;
   wire [1:0] en;
   wire [1:0] ensync;
   wire [1:0] maskb;
   wire [1:0] clkg;

   // non glitch clock enable trick
   la_inv isel (.a(sel),
                .z(selb));

   la_inv inv0 (.a(ensync[0]),
                .z(maskb[0]));

   la_inv inv1 (.a(ensync[1]),
                .z(maskb[1]));

   la_and2 ien0 (.a(selb),
                 .b(maskb[1]), // en once clk1 is safely zero
                 .z(en[0]));

   la_and2 ien1 (.a(sel),
                 .b(maskb[0]), // en once clk0 is safely zero
                 .z(en[1]));

   // syncing logic to each clock domain
   la_dsync isync0 (.clk    (clk0),
                    .in     (en[0]),
                    .out    (ensync[0]));

   la_dsync isync1 (.clk    (clk1),
                    .in     (en[1]),
                    .out    (ensync[1]));

   // glitch free clock gating
   la_clkicgand igate0 (.clk  (clk0),
                        .te   (1'b0),
                        .en   (ensync[0]),
                        .eclk (clkg[0]));

   la_clkicgand igate1 (.clk  (clk1),
                        .te   (1'b0),
                        .en   (ensync[1]),
                        .eclk (clkg[1]));

   // or-ing one hot clocks
   la_clkor2 iorclk (.a(clkg[0]),
                     .b(clkg[1]),
                     .z(out));
`endif

endmodule
