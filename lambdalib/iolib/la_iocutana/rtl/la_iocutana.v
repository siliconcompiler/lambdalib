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
    inout             vss,     // core ground
    inout             vdd0,    // previous section vdd (shorted to vdd1)
    inout             vdd1,    // next section vdd (shorted to vdd0)
    inout [RINGW-1:0] ioring0, // previous section irong (shorted to ioring1)
    inout [RINGW-1:0] ioring1, // next section ioring (shorted to ioring0)
    // cut signals
    inout             vddio0,  // io/analog supply from section before
    inout             vddio1,  // io/analog supply from next section
    inout             vssio0,  // io/analog ground from section before
    inout             vssio1   // io/analog ground from next section
    );

endmodule
