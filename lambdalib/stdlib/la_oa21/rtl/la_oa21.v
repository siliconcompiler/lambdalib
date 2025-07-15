//#############################################################################
//# Function: Or-And (oa21) Gate                                              #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_oa21 #(
    parameter PROP = "DEFAULT"
) (
    input  a0,
    input  a1,
    input  b0,
    output z
);

    assign z = (a0 | a1) & b0;

endmodule
