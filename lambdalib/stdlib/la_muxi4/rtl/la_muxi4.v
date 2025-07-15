//#############################################################################
//# Function: 4-Input Inverting Mux                                           #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_muxi4 #(
    parameter PROP = "DEFAULT"
) (
    input  d0,
    input  d1,
    input  d2,
    input  d3,
    input  s0,
    input  s1,
    output z
);

    assign z = ~((d0 & ~s1 & ~s0) | (d1 & ~s1 & s0) | (d2 & s1 & ~s0) | (d3 & s1 & s0));

endmodule
