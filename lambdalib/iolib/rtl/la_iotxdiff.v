/*****************************************************************************
 * Function: IO bi-directional transmitter
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a generic cell that defines the standard interface of the lambda
 * differential IO transmit cell.  It is not generally synthesizable.
 *
 * ASIC specific libraries will need to use the TYPE field to select an
 * appropriate hardcoded physical cell based on the the process constraints
 * and library composition. For example, modern nodes will usually have
 * different IP cells for placing cells vertically or horizontally.
 *
 ****************************************************************************/
module la_iotxdiff
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter CFGW  = 16,        // width of core config bus
    parameter RINGW = 8          // width of io ring
    )
   (// io pad signals
    inout             padp, // differential pad output (positive)
    inout             padn, // differential pad output (negative)
    inout             vdd, // core supply
    inout             vss, // core ground
    inout             vddio, // io supply
    inout             vssio, // io ground
    // core facing signals
    input             a, // input from core
    input             oe, // output enable, 1 = active
    inout [RINGW-1:0] ioring, // generic io-ring interface
    input [ CFGW-1:0] cfg // generic config interface
    );

   // output driver with tr
   assign padp = oe ? a : 1'bz;
   assign padn = oe ? ~a : 1'bz;

endmodule
