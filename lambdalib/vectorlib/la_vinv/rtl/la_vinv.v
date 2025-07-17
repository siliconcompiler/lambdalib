//#############################################################################
//# Function: Vectorized inverter cell                                        #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_vinv #(
                 parameter N = 1,           // width of data inputs
                 parameter PROP = "DEFAULT" // custom cell property
                 )
   (
    input [N-1:0]  a,
    output [N-1:0] z
    );

   assign z = ~a;

endmodule
