/**************************************************************************
 * Function: Digital Bidirectional IO Buffer
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * ../README.md
 *
 *************************************************************************/
module la_iobidir
  #(
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter CFGW = 16,        // width of core config bus
    parameter RINGW = 8         // width of io ring
    )
   (// io pad signals
    inout             pad,    // bidirectional pad signal
    inout             vdd,    // core supply
    inout             vss,    // core ground
    inout             vddio,  // io supply
    inout             vssio,  // io ground
    // core facing signals
    input             a,      // input from core
    output            z,      // output to core
    input             ie,     // input enable, 1 = active
    input             oe,     // output enable, 1 = active
    inout [RINGW-1:0] ioring, // generic io ring
    input [CFGW-1:0]  cfg     // generic config interface
    );

   // to core
    assign z   = ie ? pad : 1'b0;

    // to pad
    assign pad = oe ? a : 1'bz;

endmodule
