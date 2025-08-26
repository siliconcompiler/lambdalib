//############################################################################
//# Function: 2-Input one-hot vectorized mux                                 #
//# Copyright: Lambda Project Authors. All rights Reserved.                  #
//# License:  MIT (see LICENSE file in Lambda repository)                    #
//############################################################################

module la_vmux2b #(parameter W = 1,           // width of mux
                   parameter PROP = "DEFAULT" // cell property
                   )
   (
    input          sel,
    input [W-1:0]  in1,
    input [W-1:0]  in0,
    output [W-1:0] out
    );

   assign out[W-1:0] = ({(W) {~sel}} & in0[W-1:0] |
                        {(W) {sel}}  & in1[W-1:0]);

endmodule
