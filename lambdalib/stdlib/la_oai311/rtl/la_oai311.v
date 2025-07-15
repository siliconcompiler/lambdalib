//#############################################################################
//# Function: Or-And-Inverter (oai311) Gate                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_oai311 #(
    parameter PROP = "DEFAULT"
) (
    input  a0,
    input  a1,
    input  a2,
    input  b0,
    input  c0,
    output z
);

    assign z = ~((a0 | a1 | a2) & b0 & c0);

endmodule
