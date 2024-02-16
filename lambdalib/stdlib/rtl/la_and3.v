//#############################################################################
//# Function: 3-Input AND Gate                                                #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_and3 #(
    parameter PROP = "DEFAULT"
) (
    input  a,
    input  b,
    input  c,
    output z
);

    assign z = a & b & c;

endmodule
