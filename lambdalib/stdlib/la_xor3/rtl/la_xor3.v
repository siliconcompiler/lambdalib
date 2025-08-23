//#############################################################################
//# Function: 3-Input XOR Gate                                                #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_xor3 #(
    parameter PROP = "DEFAULT"
) (
    input  a,
    input  b,
    input  c,
    output z
);

    assign z = a ^ b ^ c;

endmodule
