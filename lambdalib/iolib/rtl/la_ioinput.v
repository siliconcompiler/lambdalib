/**************************************************************************
 * Function: Digital Input IO Cell
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * ../README.md
 *
 *************************************************************************/
module la_ioinput
  #(
    parameter PROP = "DEFAULT", // "FIXED" ignores all ctrl inputs
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter CFGW = 16,        // width of config bus
    parameter RINGW = 8         // width of io ring
    )
   (// io pad signals
    inout             pad,   // input pad
    inout             vdd,   // core supply
    inout             vss,   // core ground
    inout             vddio, // io supply
    inout             vssio, // io ground
    // core facing signals
    output            z,     // output to core
    input             pe,    // pull enable, 1=enable
    input             ps,    // pull select, 1=pullup, 0=pulldown
    input [CFGW-1:0]  cfg,   // generic config interface
    // io ring
    inout [RINGW-1:0] ioring // generic ioring interface
    );

   assign z = pad;

`ifndef VERILATOR
   if(PROP!="FIXED") begin
      rnmos #1 (pad, vssio, pe & ~ps); // weak pulldown
      rnmos #1 (pad, vddio, pe & ps); // weak pullup
   end
`endif

endmodule
