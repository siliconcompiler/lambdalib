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
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
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
    inout [RINGW-1:0] ioring // generic ioring interface
    );

   assign z = pad;

`ifndef VERILATOR
   rnmos #1 (pad, vssio, 1'b1); // weak pulldown
`endif

endmodule
