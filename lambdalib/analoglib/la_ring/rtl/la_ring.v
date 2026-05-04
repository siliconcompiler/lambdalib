/**************************************************************************
 * Function: Generic Ring Oscillator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * A structural ring oscillator can't be simulated in verilog so we
 * drive a simulation only FREF frequency in MHz to the output as a
 * behavioral model.
 *
 *************************************************************************/
module la_ring
  #(parameter           PROP = "",    // cell property (vt, strength, ..)
    parameter           STAGES = 7,   // number of stages (must be odd #)
    parameter [8*5-1:0] GATE = "inv", // inverting gate (inv,nand2,..nor4)
    parameter           FREQ = 25     // ring oscillator frequency
    )
   (
    input  en,
    output out
    );
`ifdef VERILATOR
   // Ring oscillator is inherently analog (combinatorial loop).
   // Ring oscillator cannot be simulated (combo loop). Stub output = enable.
   assign out = en;

`elsif SIMULATION
   initial
     if (STAGES % 2 == 0) begin
        $display("ERROR: Ring oscillator stages set to %0d (even #).", STAGES);
           $finish;
     end
   // behavioral model
   localparam real HALF_PERIOD_NS = 1000.0 / (2.0 * FREQ);
   reg             clk = 1'b0;
   always #HALF_PERIOD_NS clk = ~clk;
   assign out = clk & en;

`else
   // 40-bit string encodings of GATE for width-clean compares
   localparam [8*5-1:0] INV   = "inv";
   localparam [8*5-1:0] NAND2 = "nand2";
   localparam [8*5-1:0] NAND3 = "nand3";
   localparam [8*5-1:0] NAND4 = "nand4";
   localparam [8*5-1:0] NOR2  = "nor2";
   localparam [8*5-1:0] NOR3  = "nor3";
   localparam [8*5-1:0] NOR4  = "nor4";

   wire [STAGES-1:0] stage;
   genvar            i;
   generate
      for (i = 0; i < STAGES; i = i + 1) begin : gen_stages
         if (i == 0)
           // enable gate
           la_nand2 #(.PROP(PROP)) i0 (.a(stage[STAGES-1]), .b(en),
                                       .z(stage[i]));
         else if (GATE == NAND2)
           la_nand2 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == NAND3)
           la_nand3 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                       .c(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == NAND4)
           la_nand4 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                       .c(stage[i-1]), .d(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == NOR2)
           la_nor2 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                      .z(stage[i]));
         else if (GATE == NOR3)
           la_nor3 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                      .c(stage[i-1]),
                                      .z(stage[i]));
         else if (GATE == NOR4)
           la_nor4 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                      .c(stage[i-1]), .d(stage[i-1]),
                                      .z(stage[i]));
         else begin
            la_inv #(.PROP(PROP)) i0 (.a(stage[i-1]),
                                      .z(stage[i]));
         end
      end
   endgenerate

   // output buffer
   la_buf #(.PROP(PROP)) ibuf (.a(stage[STAGES-1]), .z(out));

`endif

endmodule
