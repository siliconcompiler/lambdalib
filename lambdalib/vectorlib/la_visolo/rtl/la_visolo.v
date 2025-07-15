//#############################################################################
//# Function: Vectorized power isolation (low) cell                           #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_visolo #(
    parameter N    = 1,         // width of data inputs
    parameter PROP = "DEFAULT"  // custom cell property
) (
    input          iso,  // isolation signal
    input  [N-1:0] in,   // input
    output [N-1:0] out   // out = ~iso & in
);

    la_isolo #(
        .PROP(PROP)
    ) i0[N-1:0] (
        .iso(iso),
        .in (in[N-1:0]),
        .out(out[N-1:0])
    );

endmodule
