/**************************************************************************
 * Function: PLL
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * NOTE: Interface was derived by reviewing a number of publicly
 * open source PLLs and FPGA IP datasheets.
 *
 *************************************************************************/
module la_pll  #(parameter PROP = "", // cell property
                 parameter NREF = 1,  // number of input reference clocks
                 parameter NOUT = 1,  // number of output clocks
                 parameter REFW = 8,  // reference divider width
                 parameter FBW = 8,   // feedback divider width
                 parameter PW = 8,    // post feedback divider/phase width
                 parameter CW = 1,    // control vector width
                 parameter SW = 1     // status vector width
                 )
   (
    // supplies
    inout               vdda,     // analog supply
    inout               vdd,      // digital core supply
    inout               vddaux,   // aux core supply
    inout               vss,      // common ground
    // clocks
    input [NREF-1:0]    refclk,   // input reference clock
    output [NOUT-1:0]   clkout,   // output clocks
    // standard controls
    input               reset,    // active high async reset
    input               en,       // pll enable
    input               bypass,   // pll bypasses
    input [NREF-1:0]    clksel,   // one hot clock selector
    input [REFW-1:0]    divref,   // reference divider
    input [FBW-1:0]     divfb,    // feedback divider
    input [NOUT*PW-1:0] divpost,  // output divider
    input [NOUT*PW-1:0] phaseout, // output phase shift
    output              locked,   // pll is locked
    // user defined controls
    input [CW-1:0]      ctrl,     // user defined controls
    output [SW-1:0]     status    // user defined status
    );





endmodule
