//#############################################################################
//# Function: Differential Chip Output Buffer (with ESD protection)           #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_odiff
  #(
    parameter PROP = "DEFAULT"
    )
   (
    input  in, // input
    output z, // non inverting output
    output zb // inverted output
    );

   assign z = in;
   assign zb = ~in;

endmodule
