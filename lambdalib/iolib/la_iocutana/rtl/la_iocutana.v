/*****************************************************************************
 * Function: Analog Supply Cut IO Cell (propagates vss, vdd, and ioring)
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * ../README.md
 *
 ****************************************************************************/
module la_iocutana
  #(
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW = 8         // width of io ring
    )
   (
    // shorted signals
    inout             vss,    // core ground
    inout             vdd,    // core supply
    inout [RINGW-1:0] ioring, // generic ioring
    // cut signals
    inout             vddio,  // digital power
    inout             vssio,  // digital ground
    inout             vdda,   // analog power
    inout             vssa    // analog ground
    );

endmodule
