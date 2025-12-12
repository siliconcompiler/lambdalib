/**************************************************************************
 * Function: Generic Ring Oscillator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *************************************************************************/
module la_ring  #(parameter PROP = "", // cell property (vt, strength, ..)
                  parameter N = 7      // number of stages (must be odd #)
                  )
   (
    input  en,
    output out
    );

   wire [N-1:0] stage;

   genvar       i;
   generate
      for (i = 0; i < N; i = i + 1) begin : gen_stages
         if (i == 0)
           la_nand2 #(.PROP(PROP)) i0 (.a(stage[N-1]), .b(en), .z(stage[i]));
         else
           la_inv #(.PROP(PROP)) i0 (.a(stage[i-1]), .z(stage[i]));
      end
   endgenerate

   assign out = stage[N-1];

   // ERROR CHECKING
   initial begin
      if (N % 2 == 0) begin
         $display("ERROR: Ring oscillator stages set to %0d. Must be odd for oscillation.", N);
         $finish;
      end
    end


endmodule
