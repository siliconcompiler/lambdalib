//#############################################################################
//# Function: Synchronizer                                                    #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_dsync #(parameter PROP = "DEFAULT",
                  parameter STAGES = 2,         // synchhronizer depth
                  parameter RND = 1)            // randomize sync
   (
    input  clk, // clock
    input  in,  // input data
    output out  // synchronized data
    );

    reg     [STAGES:0] shiftreg;
    integer            sync_delay;

    always @(posedge clk) begin
        shiftreg[STAGES:0] <= {shiftreg[STAGES-1:0], in};
`ifdef SIMULATION
        sync_delay <= {$random} % 2;
`endif
    end

`ifdef SIMULATION
   assign out = (|sync_delay & (|RND)) ? shiftreg[STAGES] : shiftreg[STAGES-1];

`else
    assign out = shiftreg[STAGES-1];
`endif

endmodule
