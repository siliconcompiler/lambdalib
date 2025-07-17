//############################################################################
//# Function: N-Input one hot mux                                            #
//# Copyright: Lambda Project Authors. All rights Reserved.                  #
//# License:  MIT (see LICENSE file in Lambda repository)                    #
//############################################################################

module la_vmux #(parameter N = 1,           // number of ports
                 parameter DW = 1,          // data width
                 parameter PROP = "DEFAULT" // cell property
                 )
   (
    input [N-1:0]       sel, // select vector
    input [DW*N-1:0]    in,  // flattened input {.., in1[DW-1:0],in0[DW-1:0]}
    output reg [ W-1:0] out  // output
    );

   integer i;
   always @* begin
      out[DW-1:0] = 'b0;
      for (i = 0; i < N; i = i + 1)
        out[DW-1:0] = out[DW-1:0] | {(DW) {sel[i]}} & in[i*DW+:DW];
   end

   // TODO: Add One hot warning
   // Add generate code to map to actual la_mux sizes..

endmodule
