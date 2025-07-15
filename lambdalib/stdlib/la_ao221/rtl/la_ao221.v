//#############################################################################
//# Function: And-Or (ao221) Gate                                             #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_ao221 #(
    parameter PROP = "DEFAULT"
) (
    input  a0,
    input  a1,
    input  b0,
    input  b1,
    input  c0,
    output z
);

    assign z = (a0 & a1) | (b0 & b1) | (c0);

endmodule
