//#############################################################################
//# Function: Or-And-Inverter (oai222) Gate                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_oai222 #(
    parameter PROP = "DEFAULT"
) (
    input  a0,
    input  a1,
    input  b0,
    input  b1,
    input  c0,
    input  c1,
    output z
);

    assign z = ~((a0 | a1) & (b0 | b1) & (c0 | c1));

endmodule
