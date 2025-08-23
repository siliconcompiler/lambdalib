//#############################################################################
//# Function: Non-inverting Buffer                                            #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_buf #(
    parameter PROP = "DEFAULT"
) (
    input  a,
    output z
);

    assign z = a;

endmodule
