//#############################################################################
//# Function: Header circuit                                                  #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_header #(
    parameter PROP = "DEFAULT"
) (
    input  sleep,  // 1 = disabled vdd
    input  vddin,  // input supply
    output vddout  // gated output supply
);

`ifdef VERILATOR
    // pmos: passes when gate=0; when off, supply rail drops
    assign vddout = vddin & ~sleep;
`else
    pmos m0 (vddout, vddin, sleep);  //d,s,g
`endif

endmodule
