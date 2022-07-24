/*****************************************************************************
 * Function: IO corner cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iocorner
  #(
    parameter TYPE = "DEFAULT" // cell type
    )
   (
    inout vdd, // core supply
    inout vss, // core ground
    inout vddio, // io supply
    inout vssio // io ground
    );

endmodule
