//#############################################################################
//# Function: Synchronizer with async reset                                   #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################
module la_drsync #(parameter PROP = "DEFAULT",
                   parameter STAGES = 2, // synchronizer depth
                   parameter RND = 1)    // randomize simulation delay
   (
    input  clk,    // clock
    input  in,     // input data
    input  nreset, // async active low reset
    output out     // synchronized data
    );

    reg [STAGES:0] shiftreg;

    always @(posedge clk or negedge nreset)
        if (!nreset)
          shiftreg[STAGES:0] <= 'b0;
        else
          shiftreg[STAGES:0] <= {shiftreg[STAGES-1:0], in};

`ifdef SIM
   integer        sync_delay;
   always @(posedge clk)
     sync_delay <= {$random} % 2;
   assign out = (|sync_delay & (|RND)) ? shiftreg[STAGES] : shiftreg[STAGES-1];
`else
   assign out = shiftreg[STAGES-1];
`endif

endmodule
