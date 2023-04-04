//#############################################################################
//# Function: N-Input one hot mux                                             #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_mux
  #(parameter N    = 1,        // number of ports
    parameter DW    = 1,       // data width
    parameter PROP = "DEFAULT" // cell property
    )
   (
    input [N-1:0]      sel, // select vector
    input [DW*N-1:0]   in, // concatenated input {..,in1[DW-1:0],in0[DW-1:0]}
    output reg [DW-1:0] out  // output
    );

   integer 	    i;
   always @*
     begin
	out[DW-1:0] = 'b0;
	for(i=0;i<N;i=i+1)
	  out[DW-1:0] = out[DW-1:0] | {(DW){sel[i]}} & in[((i+1)*DW-1)-:DW];
     end

   //TODO: Add One hot warning

endmodule
