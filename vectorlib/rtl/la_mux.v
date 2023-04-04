//#############################################################################
//# Function: N-Input one hot mux                                             #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_mux
  #(parameter N    = 1,        // width of mux
    parameter M    = 1,        // number of input vectors
    parameter PROP = "DEFAULT" // cell property
    )
   (
    input [M-1:0]      sel, // select vector
    input [M*N-1:0]    in,  // concatenated input {..,in1[N-1:0],in0[N-1:0]}
    output reg [N-1:0] out  // output
    );

   integer 	    i;
   always @*
     begin
	out[N-1:0] = 'b0;
	for(i=0;i<M;i=i+1)
	  out[N-1:0] = out[N-1:0] | {(N){sel[i]}} & in[((i+1)*N-1)-:N];
     end

   //TODO: Add One hot warning

endmodule
