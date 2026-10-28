/*****************************************************************************
 * Function: IO Supply Cut IO Cell (propagates vss, vdd, and ioring)
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * NOTE: This cell can only be used when the adjacent sections (0/1)
 * actually have identical ioring, vss,vdd. If this is not the case,
 * then there will be a mismatch between netlist and layout because the
 * cut cell vss/vdd/ioring extends across the cell causing a short when
 * abutted.
 *
 ****************************************************************************/
module la_iocutvddio
  #(
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW = 8         // width of io ring
    )
   (
    // shorted signals
    inout             vss,    // core ground
    inout             vdd,    // core vdd
    inout [RINGW-1:0] ioring, // io control ring
    // cut signals
    inout             vddio0, // io/analog supply from section before
    inout             vddio1, // io/analog supply from next section
    inout             vssio0, // io/analog ground from section before
    inout             vssio1  // io/analog ground from next section
    );

endmodule
