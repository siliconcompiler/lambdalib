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
    parameter real FREF = 25.0   // clkin frequency (MHz)
    )
   (
    // supplies
    inout                             vdda,      // analog supply
    inout                             vdd,       // digital core supply
    inout                             vddaux,    // aux core supply
    inout                             vss,       // common ground
    // clocks
    input [NIN-1:0]                   clkin,     // input reference clock
    output [NOUT-1:0]                 clkout,    // output clocks (post divided)
    input                             clkfbin,   // input feedback clock (optional)
    output                            clkfbout,  // output feedback clock (optional)
    output                            clkvco,    // high frequency vco clock
    // standard controls
    input                             reset,     // active high async reset
    input                             en,        // pll enable
    input                             bypass,    // pll bypass
    input [(NIN>1?$clog2(NIN):1)-1:0] clksel,    // clock select
    input [NOUT-1:0]                  clken,     // output clock enable(s)
    input [DIVINW-1:0]                divin,     // reference divider
    input [DIVFBW-1:0]                divfb,     // feedback divider
    input [DIVFRACW-1:0]              divfrac,   // fractional feedback divider
    input [NOUT*DIVOUTW-1:0]          divout,    // output divider
    input [NOUT*PHASEW-1:0]           phase,     // output phase shift
    output                            freqlock,  // pll frequency lock
    output                            phaselock, // pll phase lock
    // user defined signals (defined per unique PLL)
    input [CW-1:0]                    ctrl,      // controls
    output [SW-1:0]                   status     // status
    );

   localparam LOCKTIME = 32; // lock cycles

   //####################################
   // Input clock mux
   //####################################

   wire       clk;

   assign clk = clkin[(NIN == 1) ? 0 : clksel];

   //####################################
   // VCO Clock
   //####################################

   real t_vco_period;
   real t_ref_period;
   real n_int;
   real n_frac;
   real n_eff;
   real frac_scale;
   integer k;

   // Trigger calculation only when the PLL is actually enabled
   always @(posedge en) begin : calc_setup

      // Calculate 2^DIVFRACW
      frac_scale = 1.0;
      for (k = 0; k < DIVFRACW; k = k + 1) begin
         frac_scale = frac_scale * 2.0;
      end

      // Sample the ports now that en is high
      n_int  = divfb + 0.0;
      n_frac = (divfrac + 0.0) / frac_scale;
      n_eff  = n_int + n_frac;

      t_ref_period = 1000.0 / FREF;

      // Safety check to prevent simulation hang
      if (n_eff > 0.0001) begin
         t_vco_period = (t_ref_period * (divin + 0.0)) / n_eff;
      end else begin
         t_vco_period = 0.0;
         $display("[PLL SIM] ERROR: n_eff is zero. VCO will not start.");
      end

      $display("[PLL SIM] @ %0t: Ref Period: %0.3f ns, VCO Period: %0.3f ns",
               $time, t_ref_period, t_vco_period);
   end

   reg  vco_clk = 0;
   always begin
      // PLL is disabled or configuration is invalid
      if (!en || t_vco_period <= 0) begin
          vco_clk = 0;             // disable clock for en=0
          @(posedge en);           // wait for enable
          #0.1;                    // ? let tvco math settle
      end
      // PLL is enabled
      else begin
          #(t_vco_period/2.0);
          if (en) begin            // toggle vco when pllen=1
              vco_clk = ~vco_clk;
          end
      end
   end

   assign clkvco = vco_clk;

   //####################################
   // Feedback Divider ("N")
   //####################################

   reg fb_clk;
   integer fb_cnt;

   always @(posedge vco_clk or negedge en) begin
      if (~en) begin
         fb_cnt <= 0;
         fb_clk <= 0;
      end
      else if (fb_cnt == (divfb-1)) begin
         fb_cnt <= 0;
         fb_clk <= ~fb_clk;
      end
      else begin
         fb_cnt <= fb_cnt + 1;
      end
   end

   assign clkfbout = fb_clk;

   //####################################
   // Output Dividers
   //####################################

   genvar j;
   generate
      for (j=0; j<NOUT; j=j+1) begin : gen_out
         reg out_clk;
         integer cnt;

         wire [DIVOUTW-1:0] div = divout[j*DIVOUTW +: DIVOUTW];

         // Added negedge en to the sensitivity list
         always @(posedge vco_clk or posedge reset or negedge en) begin
            if (reset || !en) begin
               cnt <= 0;
               out_clk <= 0;
            end
            else if (div <= 1) begin
               out_clk <= vco_clk;
            end
            else if (cnt >= (div/2-1)) begin
               cnt <= 0;
               out_clk <= ~out_clk;
            end
            else begin
               cnt <= cnt + 1;
            end
         end
         assign clkout[j] = bypass ? clk : freqlock & out_clk & clken[j];
      end
   endgenerate

   //####################################
   // Phase shift
   //####################################

   // TODO

   //####################################
   // PLL LOCK
   //####################################

   integer lock_cnt;
   reg freqlock_r, phaselock_r;

   always @(posedge clkfbout or negedge en) begin
      if (!en) begin
         lock_cnt    <= 0;
         freqlock_r  <= 0;
         phaselock_r <= 0;
      end
      else if (lock_cnt < LOCKTIME) begin
         lock_cnt <= lock_cnt + 1;
      end
      else begin
         freqlock_r  <= 1;
         phaselock_r <= 1;
      end
   end

   assign freqlock  = freqlock_r;
   assign phaselock = phaselock_r;
   assign status    = {SW{1'b0}};

endmodule
