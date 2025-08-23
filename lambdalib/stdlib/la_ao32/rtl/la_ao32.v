//#############################################################################
//# Function: And-Or (ao32) Gate                                              #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_ao32 #(
    parameter PROP = "DEFAULT"
) (
    input  a0,
    input  a1,
    input  a2,
    input  b0,
    input  b1,
    output z
);

    assign z = (a0 & a1 & a2) | (b0 & b1);

endmodule
