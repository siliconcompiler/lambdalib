//#############################################################################
//# Function: Differential Chip Input Buffer (with ESD protection)            #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_idiff
  #(
    parameter PROP = "DEFAULT"
    )
   (
    input  in, // positive input
    input  inb, // negative input
    output z // output
    );

   assign z = (in & ~inb)  | // for proper diff inputs
              (~in & ~inb);  // fail on non diff input

endmodule
