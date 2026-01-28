/******************************************************************************
 * Function: PLL Simulation Model
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Coarse simulation model for la_pll.
 *
 * !!! DISCLAIMER: DO NOT USE THIS MODEL FOR ASIC SIGNOFF SIMULATIONS !!!!
 *
 ******************************************************************************/
`timescale 1ns/1ps
module la_pll_sim
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
    parameter real FREF = 25.0   // clkin frequency (for simulation model)
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
    input [NIN-1:0]          clksel,    // one hot clock selector
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

   //####################################
   // One hot clock input selector
   //####################################
   reg     sel_clk;
   integer i;

   always @(*) begin
      sel_clk = 1'b0;
      for (i=0; i<NIN; i=i+1) begin
         if (clksel[i])
           sel_clk = clkin[i];
      end
   end

   //####################################
   // VCO Clock
   //####################################

   // calculate vco period
   real t_vco;
   initial begin
      t_vco = FREF * (divfb / divin); // multiply FREF by N/M
   end

   // high speed vco clock
   reg vco_clk;
   initial vco_clk = 0;
   always begin
      #(t_vco/2.0) vco_clk = ~vco_clk;
   end

   // output assignment
   assign clkvco = vco_clk;

   //####################################
   // Feedback Clock
   //####################################

   // calculate feedback clock period
   real t_fb;
   initial begin
      t_fb  = t_vco * divfb;
   end

   // N/M feedback loop
   reg fb_clk;
   initial fb_clk = 0;
   always begin
      #(t_fb/2.0) fb_clk = ~fb_clk;
   end

   // output assignment
   assign clkfbout = fb_clk;

   //####################################
   // Output Dividers
   //####################################

   // Output dividers
   genvar j;
   generate
      for (j=0; j<NOUT; j=j+1) begin : gen_div
         reg div_clk;
         integer cnt;
         always @(posedge vco_clk or posedge reset) begin
            if (reset) begin
               cnt <= 0;
               div_clk <= 0;
            end else if (bypass) begin
               div_clk <= sel_clk;
            end else if (divout[j*DIVOUTW +: DIVOUTW] <= 1) begin
               div_clk <= vco_clk;
            end else if (cnt == (divout[j*DIVOUTW +: DIVOUTW]/2 - 1)) begin
               div_clk <= ~div_clk;
               cnt <= 0;
            end else begin
               cnt <= cnt + 1;
            end
         end
         assign clkout[j] = div_clk;
      end
   endgenerate

    // Lock signals (behavioral)
    integer lock_cnt;
    reg freqlock_r, phaselock_r;
    always @(posedge clkfb or posedge reset) begin
        if (reset) begin
            lock_cnt <= 0;
            freqlock_r <= 0;
            phaselock_r <= 0;
        end else if (lock_cnt < 16) begin
            lock_cnt <= lock_cnt + 1;
            freqlock_r <= 0;
            phaselock_r <= 0;
        end else begin
            freqlock_r <= 1;
            phaselock_r <= 1;
        end
    end

    assign freqlock = freqlock_r;
    assign phaselock = phaselock_r;

    // Status (user-defined)
    assign status = {SW{1'b0}};


   //####################################
   // Output signal assignment
   //####################################



endmodule
