/*****************************************************************************
 * Function: Supply Ring Cut IO Cell
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * ../README.md
 *
 ****************************************************************************/
module la_iocut
  #(
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW = 8         // width of io ring
    )
   (
    // ground never cut
    inout             vss,   // core ground
    // cut these
    inout             vdd0,   // core supply from section before
    inout             vdd1,   // core supply from next section
    inout             vddio0, // io supply from section before
    inout             vddio1, // io supply from next section
    inout             vssio0, // io ground from section before
    inout             vssio1, // io ground from next section
    inout [RINGW-1:0] ioring0,// generic ioring interface from section before
    inout [RINGW-1:0] ioring1 // generic ioring interface from next section
    );

endmodule
