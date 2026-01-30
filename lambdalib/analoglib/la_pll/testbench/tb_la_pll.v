`timescale 1ns/1ps

module tb_la_pll;

    // Parameters matches the simulation model defaults
    parameter NIN      = 1;
    parameter NOUT     = 1;
    parameter DIVINW   = 8;
    parameter DIVFBW   = 8;
    parameter DIVOUTW  = 8;
    parameter PHASEW   = 8;
    parameter real FREF = 25.0;

    // Simulation Signals
    reg [NIN-1:0]   clkin;
    wire [NOUT-1:0] clkout;
    wire            clkvco;
    reg             reset;
    reg             en;
    reg             bypass;
    reg [(NIN>1?$clog2(NIN):1)-1:0]  clksel;
    reg             lock_timeout;

    reg [DIVINW-1:0]  divin;
    reg [DIVFBW-1:0]  divfb;
    reg [NOUT*DIVOUTW-1:0] divout;

    wire freqlock;
    wire phaselock;

    // Analog/Supply stubs (inout requirements)
    wire vdda, vdd, vddaux, vss;
    assign vss = 1'b0;

    // Instantiate the PLL Simulation Model
    la_pll #(.NIN(NIN),
             .NOUT(NOUT),
             .FREF(FREF))
   dut (
        .clkin(clkin),
        .clkout(clkout[NOUT-1:0]),
        .clkfbin(1'b0),     // Internal feedback mode
        .clkfbout(),
        .clkvco(clkvco),
        .reset(reset),
        .en(en),
        .bypass(bypass),
        .clksel(clksel),
        .clken({NOUT{1'b1}}),
        .divin(divin),
        .divfb(divfb),
        .divfrac(8'b0),
        .divout(divout),
        .phase({NOUT*PHASEW{1'b0}}),
        .freqlock(freqlock),
        .phaselock(phaselock),
        .ctrl(1'b0),
        .status(),
        // Supplies
        .vdda(vdda),
        .vdd(vdd),
        .vddaux(vddaux),
        .vss(vss));

    // 1. Generate Reference Clock (25 MHz -> 40ns period)
    initial begin
        clkin = 0;
        forever #20 clkin = ~clkin;
    end

    // 2. Stimulus Block
    initial begin
       // Setup Waveform Dumping
       $dumpfile("pll_sim.vcd");
       $dumpvars(0, tb_la_pll);

       // Initialize Controls
       reset   = 1;
       en      = 0;
       bypass  = 0;
       clksel  = 1'b1; // Select clkin[0]

       // Configure for 100MHz output from 25MHz ref
       // Fvco = Fref * (divfb / divin) = 25 * (40 / 1) = 1000 MHz
       // Fout = Fvco / divout = 1000 / 10 = 100 MHz
       divin   = 8'd1;
       divfb   = 8'd40;
       divout  = 8'd10;

       #100;
       reset = 0;
       #50;

       $display("[%0t] Enabling PLL...", $time);
       en = 1;

       lock_timeout = 0;
       fork
          // Thread A: Wait for lock
          begin : a_thread
             wait(freqlock);
          end
          // Thread B: Wait for timeout
          begin : b_thread
             #10000;
             lock_timeout = 1;
          end
       join

       if (lock_timeout && !freqlock) begin
          $display("[%0t] ERROR: PLL failed to lock!", $time);
          $finish;
       end
       $display("[%0t] PLL Frequency Locked!", $time);

       #500;

       // Test Bypass Mode
       $display("[%0t] Testing Bypass Mode (Output should match 25MHz Ref)...", $time);
       bypass = 1;
       #200;
       bypass = 0;
       #200;

       $display("[%0t] Simulation Complete.", $time);
       $finish;
    end

endmodule
