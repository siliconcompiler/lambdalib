//############################################################################
//# Function: 3-Input one-hot vectorized mux                                 #
//# Copyright: Lambda Project Authors. All rights Reserved.                  #
//# License:  MIT (see LICENSE file in Lambda repository)                    #
//############################################################################

module la_vmux3 #(parameter DW = 1,          // width of mux
                  parameter PROP = "DEFAULT" // cell property
                  )
   (
    input           sel2,
    input           sel1,
    input           sel0,
    input [DW-1:0]  in2,
    input [DW-1:0]  in1,
    input [DW-1:0]  in0,
    output [DW-1:0] out
    );

   assign out[DW-1:0] = ({(DW){sel0}} & in0[DW-1:0] |
                         {(DW){sel1}} & in1[DW-1:0] |
                         {(DW){sel2}} & in2[DW-1:0]);

endmodule
