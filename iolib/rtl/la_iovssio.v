/*****************************************************************************
 * Function: IO supply cell (vssio)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovssio
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8         // width of io ring
    )
   (
    inout 	vdd, // core supply
    inout 	vss, // core ground
    inout 	vddio, // io supply
    inout 	vssio, // io ground
    inout [7:0] ioring // generic io-ring interface
    );

endmodule
