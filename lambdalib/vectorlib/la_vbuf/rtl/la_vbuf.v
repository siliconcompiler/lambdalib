//#############################################################################
//# Function: Vectorized buffer cell                                          #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_vbuf #(
    parameter N    = 1,         // width of data inputs
    parameter PROP = "DEFAULT"  // custom cell property
) (
    input  [N-1:0] a,
    output [N-1:0] z
);

    la_buf #(
        .PROP(PROP)
    ) i0[N-1:0] (
        .a(a[N-1:0]),
        .z(z[N-1:0])
    );

endmodule
