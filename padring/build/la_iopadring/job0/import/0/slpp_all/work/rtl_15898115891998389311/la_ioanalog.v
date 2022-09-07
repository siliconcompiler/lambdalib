/*****************************************************************************
 * Function: IO analog pass-through cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_ioanalog
  #(
    parameter TYPE = "DEFAULT", // cell type
    parameter SIDE  = "NO",     // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (// io pad signals
    inout 	      pad, // bidirectional pad signal
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring, // generic io-ring interface
    // core interface
    input 	      a, // analog input from core
    output 	      z // analog output to core
    );

endmodule
