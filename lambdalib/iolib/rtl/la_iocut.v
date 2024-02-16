/*****************************************************************************
 * Function: IO cut cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iocut #(
    parameter TYPE  = "DEFAULT",  // cell type
    parameter SIDE  = "NO",       // "NO", "SO", "EA", "WE"
    parameter RINGW = 8           // width of io ring
) (
    // ground never cut
    inout vss
);

endmodule
