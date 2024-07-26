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
    inout vss
    );

   // TODO: interface?

endmodule
