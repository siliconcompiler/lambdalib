//#############################################################################
//# Function: 4-Input one-hot vectorized mux                                  #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_vmux4 #(
    parameter N    = 1,         // width of mux
    parameter PROP = "DEFAULT"  // cell property
) (
    input          sel3,
    input          sel2,
    input          sel1,
    input          sel0,
    input  [N-1:0] in3,
    input  [N-1:0] in2,
    input  [N-1:0] in1,
    input  [N-1:0] in0,
    output [N-1:0] out    //selected data output
);

    assign out[N-1:0] = ({(N){sel0}} & in0[N-1:0] |
            {(N){sel1}} & in1[N-1:0] |
            {(N){sel2}} & in2[N-1:0] |
            {(N){sel3}} & in3[N-1:0]);

endmodule
