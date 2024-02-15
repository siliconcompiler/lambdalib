//#############################################################################
//# Function: Non-inverting Clock Buffer                                      #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_clkbuf #(
    parameter PROP = "DEFAULT"
) (
    input  a,
    output z
);

    assign z = a;

endmodule
