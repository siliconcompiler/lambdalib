//#############################################################################
//# Function:  Positive edge-triggered static D-type flop-flop with async     #
//#            active low reset.                                              #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:   MIT (see LICENSE file in Lambda repository)                    #
//#############################################################################

module la_dffrq #(
    parameter PROP = "DEFAULT"
) (
    input      d,
    input      clk,
    input      nreset,
    output reg q
);

    always @(posedge clk or negedge nreset)
        if (!nreset) q <= 1'b0;
        else q <= d;

endmodule
