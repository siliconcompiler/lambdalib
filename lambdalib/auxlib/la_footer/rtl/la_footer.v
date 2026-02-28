//#############################################################################
//# Function: Footer circuit                                                  #
//# Copyright: Lambda Project Authors. All rights Reserved.                   #
//# License:  MIT (see LICENSE file in Lambda repository)                     #
//#############################################################################

module la_footer #(
    parameter PROP = "DEFAULT"
) (
    input  nsleep,  // 0 = disabled ground
    input  vssin,   // input supply
    output vssout   // gated output supply
);

`ifdef VERILATOR
    // nmos: passes when gate=1; when off, ground rail floats high
    assign vssout = vssin | ~nsleep;
`else
    nmos m0 (vssout, vssin, nsleep);  //d,s,g
`endif

endmodule
