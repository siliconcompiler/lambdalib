/**************************************************************************
 * Function: Generic Ring Oscillator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *************************************************************************/
module la_ring  #(parameter PROP = "",   // cell property (vt, strength, ..)
                  parameter STAGES = 7,  // number of stages (must be odd #)
                  parameter GATE = "inv" // inverting gate (inv,nand2,nand3,..nor4)
                  )
   (
    input  en,
    output out
    );

`ifdef VERILATOR
   // Ring oscillator is inherently analog (combinatorial loop).
   // Ring oscillator cannot be simulated (combo loop). Stub output = enable.
   assign out = en;
`else
   wire [STAGES-1:0] stage;

   genvar       i;
   generate
      for (i = 0; i < STAGES; i = i + 1) begin : gen_stages
         if (i == 0)
           la_nand2 #(.PROP(PROP)) i0 (.a(stage[STAGES-1]), .b(en),
                                       .z(stage[i]));
         else if (GATE == "inv")
           la_inv #(.PROP(PROP)) i0 (.a(stage[i-1]),
                                     .z(stage[i]));
         else if (GATE == "nand2")
           la_nand2 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == "nand3")
           la_nand3 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]), .c(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == "nand4")
           la_nand4 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]), .c(stage[i-1]), .d(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == "nor2")
           la_nor2 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]),
                                       .z(stage[i]));
         else if (GATE == "nor3")
           la_nor3 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]), .c(stage[i-1]),
                                      .z(stage[i]));
         else if (GATE == "nor4")
           la_nor4 #(.PROP(PROP)) i0 (.a(stage[i-1]), .b(stage[i-1]), .c(stage[i-1]), .d(stage[i-1]),
                                      .z(stage[i]));
         else
           begin
              initial
                $display("ERROR: Unimplemented gate type: %s", GATE);
           end
      end
   endgenerate

   la_buf #(.PROP(PROP)) ibuf (.a(stage[STAGES-1]), .z(out));
`endif

   // ERROR CHECKING
   initial
     begin
        if (STAGES % 2 == 0) begin
           $display("ERROR: Ring oscillator stages set to %0d. Must be odd for oscillation.", STAGES);
           $finish;
        end
     end
endmodule
