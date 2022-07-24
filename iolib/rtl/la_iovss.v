/*****************************************************************************
 * Function: IO supply cell (vss)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovss
  #(
    parameter TYPE = "DEFAULT" // cell type
    )
   (
    inout 	vdd, // core supply
    inout 	vss, // core ground
    inout 	vddio, // io supply
    inout 	vssio, // io ground
    inout [7:0] ioring // generic io-ring interface
    );

endmodule
