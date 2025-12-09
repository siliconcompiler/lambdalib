//############################################################################
//# Function: 7-Input one-hot vectorized mux                                 #
//# Copyright: Lambda Project Authors. All rights Reserved.                  #
//# License:  MIT (see LICENSE file in Lambda repository)                    #
//############################################################################

module la_vmux7 #(parameter W = 1,           // width of mux
                  parameter PROP = "DEFAULT" // cell property
                  )
   (
    input          sel6,
    input          sel5,
    input          sel4,
    input          sel3,
    input          sel2,
    input          sel1,
    input          sel0,
    input [W-1:0]  in6,
    input [W-1:0]  in5,
    input [W-1:0]  in4,
    input [W-1:0]  in3,
    input [W-1:0]  in2,
    input [W-1:0]  in1,
    input [W-1:0]  in0,
    output [W-1:0] out
    );

   assign out[W-1:0] = (({(W){sel0}} & in0[W-1:0]) |
                        ({(W){sel1}} & in1[W-1:0]) |
                        ({(W){sel2}} & in2[W-1:0]) |
                        ({(W){sel3}} & in3[W-1:0]) |
                        ({(W){sel4}} & in4[W-1:0]) |
                        ({(W){sel5}} & in5[W-1:0]) |
                        ({(W){sel6}} & in6[W-1:0]));

endmodule
