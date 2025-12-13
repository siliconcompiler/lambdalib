/**************************************************************************
 * Function: PLL
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * NOTE: The generic interface was derived by reviewing a number of
 * publicly open source PLLs and FPGA IP datasheets and via llm
 * promting.
 *
 * This is a synthesizable zeroth order PLL model that only
 * supports one operating mode: clkout=clkref.
 *
 * Behavior of control signals such as divpost may differ between
 * PLLs. For exact simulation behavior, see the simulation model. As long
 * as these values can be set freely via a register this should not be
 * a problem in real designs.
 *
 *************************************************************************/
module la_pll  #(parameter PROP = "", // cell property
                 parameter NIN = 1,   // number of input reference clocks
                 parameter NOUT = 1,  // number of output clocks
                 parameter REFW = 8,  // reference divider width
                 parameter FBW = 8,   // feedback divider width
                 parameter PW = 8,    // post feedback divider/phase width
                 parameter CW = 1,    // control vector width
                 parameter SW = 1     // status vector width
                 )
   (
    // supplies
    inout               vdda,    // analog supply
    inout               vdd,     // digital core supply
    inout               vddaux,  // aux core supply
    inout               vss,     // common ground
    // clocks
    input [NIN-1:0]     refclk,  // input reference clock
    output [NOUT-1:0]   clkout,  // output clocks
    // standard controls
    input               reset,   // active high async reset
    input               en,      // pll enable
    input               bypass,  // pll bypasses
    input [NIN-1:0]     clksel,  // one hot clock selector
    input [REFW-1:0]    divref,  // reference divider
    input [FBW-1:0]     divfb,   // feedback divider
    input [NOUT*PW-1:0] divpost, // output divider
    input [NOUT*PW-1:0] phase,   // output phase shift
    output              locked,  // pll is locked
    // user defined signals (defined per unique PLL)
    input [CW-1:0]      ctrl,    // controls
    output [SW-1:0]     status   // status
    );

   genvar i;

   wire   clk;

   // input clock selector
   assign clk = |(refclk[NIN-1:0] & clksel[NIN-1:0]);

   // model bypass and pll en
   for (i = 0; i < NOUT; i = i + 1) begin : gen_out
      assign clkout[i] = bypass ? clk : clk & en;
   end

   // zero latency lock time
   assign locked = en;


endmodule
