//#############################################################################
//# Function:  Reset synchronizer (async assert, sync deassert)               #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:   MIT (see LICENSE file in Lambda repository)                    #
//#############################################################################

module la_rsync
  #(parameter PROP = "DEFAULT")
   (
    input  clk, // clock
    input  nrst_in, // async reset input
    output nrst_out // async assert, sync deassert reset
   );

   localparam STAGES=2;

   reg [STAGES-1:0] sync_pipe;
   always @ (posedge clk or negedge nrst_in)
     if(!nrst_in)
       sync_pipe[STAGES-1:0] <= 'b0;
     else
       sync_pipe[STAGES-1:0] <= {sync_pipe[STAGES-2:0],1'b1};
   assign nrst_out = sync_pipe[STAGES-1];

endmodule
