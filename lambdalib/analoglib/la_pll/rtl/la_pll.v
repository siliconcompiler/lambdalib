/******************************************************************************
 * Function: PLL
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * NOTE: The generic PLL interface was derived by reviewing a number of
 * publicly open source PLLs and FPGA IP datasheets as well as LLM
 * prompting.
 *
 * Basic operation of all output clocks:
 *
 * freq_vco = freq_clkin * (divfb / divin)
 * freq_clkout = freq_vco / (divout)
 *
 * In real ASIC design the la_pll is replaced by an actual PLL implementation.
 *
 * A coarse first order simulation model can be run by setting `LAMBDASIM
 * during compilation. Behavior of control signals such as divpost may differ
 * between PLLs. For exact simulation behavior, use the actual designer supplied
 * mixed signal simulation model.
 *
 * DIVIN corresponds exactly to "N" (0 is an illegal value).
 * DIVFB corresponds exactly to "M" (0 is an illegal value).
 *
 *******************************************************************************/
`timescale 1ns/1ps
module la_pll
  #(parameter      NIN = 1,      // number of input reference clocks
    parameter      NOUT = 1,     // number of output clocks
    parameter      DIVINW = 8,   // input divider width
    parameter      DIVFBW = 8,   // feedback divider width
    parameter      DIVFRACW = 8, // fractional feedback divider width
    parameter      DIVOUTW = 8,  // output divider width
    parameter      PHASEW = 8,   // phase shift adjust width
    parameter      CW = 1,       // control vector width
    parameter      SW = 1,       // status vector width
    parameter      PROP = "",    // cell property
    parameter real FREF = 25.0   // clkin frequency (MHz)
    )
   (
    // supplies
    inout                    vdda,      // analog supply
    inout                    vdd,       // digital core supply
    inout                    vddaux,    // aux core supply
    inout                    vss,       // common ground
    // clocks
    input [NIN-1:0]          clkin,     // input reference clock
    output [NOUT-1:0]        clkout,    // output clocks (post divided)
    input                    clkfbin,   // input feedback clock (optional)
    output                   clkfbout,  // output feedback clock (optional)
    output                   clkvco,    // high frequency vco clock
    // standard controls
    input                    reset,     // active high async reset
    input                    en,        // pll enable
    input                    bypass,    // pll bypass
    input [NIN-1:0]          clksel,    // one hot input clock selector
    input [NOUT-1:0]         clken,     // output clock enable(s)
    input [DIVINW-1:0]       divin,     // reference divider
    input [DIVFBW-1:0]       divfb,     // feedback divider
    input [DIVFRACW-1:0]     divfrac,   // fractional feedback divider
    input [NOUT*DIVOUTW-1:0] divout,    // output divider
    input [NOUT*PHASEW-1:0]  phase,     // output phase shift
    output                   freqlock,  // pll frequency lock
    output                   phaselock, // pll phase lock
    // user defined signals (defined per unique PLL)
    input [CW-1:0]           ctrl,      // controls
    output [SW-1:0]          status     // status
    );

`ifdef VERILATOR

   //###############################################
   // Limited model (Verilator compatible)
   //###############################################

   /* verilator lint_off UNUSEDPARAM */
   /* verilator lint_off UNUSEDSIGNAL */

   localparam real NO_FREF = FREF;
   localparam      NO_PROP = PROP;
   localparam      NCW = (1 + DIVINW + DIVFBW + DIVFRACW +
                          NOUT * (DIVOUTW + PHASEW)+CW);

   // these inputs are not modeled!!
   wire [NCW-1:0] unconnected = {clkfbin,
                                 divin,
                                 divfb,
                                 divfrac,
                                 divout,
                                 phase,
                                 ctrl};

   wire clk;

   // Input clock mux
   assign clk = |(clkin[NIN-1:0] & clksel[NIN-1:0]);

   // N/M=1 mode
   assign clkvco   = clk & en & ~reset;
   assign clkfbout = clkvco;

   // Minimal bypass mode model
   genvar i;
   for (i = 0; i < NOUT; i = i + 1) begin : gen_out
      assign clkout[i] = bypass ? clk : clkvco & clken[i];
   end

   // Lock model
   assign freqlock = en;
   assign phaselock = en;

   // not modeling status (PLL specific)
   assign status = 'b0;

`else

   //###############################################
   // Timed Verilog model (Icarus compatible)
   //###############################################

   la_pll_sim #(.NIN(NIN),
                .NOUT(NOUT),
                .DIVINW(DIVINW),
                .DIVFBW(DIVFBW),
                .DIVFRACW(DIVFRACW),
                .DIVOUTW(DIVOUTW),
                .PHASEW(PHASEW),
                .CW(CW),
                .SW(SW),
                .PROP(PROP),
                .FREF(FREF))
   ipll (/*AUTOINST*/
         // Outputs
         .clkout                (clkout[NOUT-1:0]),
         .clkfbout              (clkfbout),
         .clkvco                (clkvco),
         .freqlock              (freqlock),
         .phaselock             (phaselock),
         .status                (status[SW-1:0]),
         // Inouts
         .vdda                  (vdda),
         .vdd                   (vdd),
         .vddaux                (vddaux),
         .vss                   (vss),
         // Inputs
         .clkin                 (clkin[NIN-1:0]),
         .clkfbin               (clkfbin),
         .reset                 (reset),
         .en                    (en),
         .bypass                (bypass),
         .clksel                (clksel[NIN-1:0]),
         .clken                 (clken[NOUT-1:0]),
         .divin                 (divin[DIVINW-1:0]),
         .divfb                 (divfb[DIVFBW-1:0]),
         .divfrac               (divfrac[DIVFRACW-1:0]),
         .divout                (divout[NOUT*DIVOUTW-1:0]),
         .phase                 (phase[NOUT*PHASEW-1:0]),
         .ctrl                  (ctrl[CW-1:0]));

`endif

endmodule
