//############################################################################
//# Function: 3-Input one-hot vectorized mux                                 #
//# Copyright: Lambda Project Authors. All rights Reserved.                  #
//# License:  MIT (see LICENSE file in Lambda repository)                    #
//############################################################################

module la_vmux3 #(parameter W = 1,          // width of mux
                  parameter PROP = "DEFAULT" // cell property
                  )
   (
    input          sel2,
    input          sel1,
    input          sel0,
    input [W-1:0]  in2,
    input [W-1:0]  in1,
    input [W-1:0]  in0,
    output [W-1:0] out
    );

   assign out[W-1:0] = ({(W){sel0}} & in0[W-1:0] |
                        {(W){sel1}} & in1[W-1:0] |
                        {(W){sel2}} & in2[W-1:0]);

endmodule
