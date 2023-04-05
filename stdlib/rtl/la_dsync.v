//#############################################################################
//# Function: Synchronizer                                                    #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_dsync
  #(parameter PROP = "DEFAULT")
   (
    input  clk, // clock
    input  in, // input data
    output out     // synchronized data
    );

   localparam STAGES=2;

   reg [STAGES-1:0] shiftreg;

   always @ (posedge clk)
     shiftreg[STAGES-1:0] <= {shiftreg[STAGES-2:0],in};

   assign out = shiftreg[STAGES-1];

endmodule
