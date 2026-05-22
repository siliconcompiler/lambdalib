`timescale 1ns/1ps

module tb_la_vclkmux();

    parameter N = 4;
    parameter STAGES = 2;

    reg  [N-1:0] clkin;
    reg          nreset;
    reg  [N-1:0] sel;
    wire         clkout;

    // --- Clock Generation ---
    // Different frequencies to test cross-domain robustness
    initial clkin[0] = 0; always #5.0  clkin[0] = ~clkin[0]; // 100 MHz
    initial clkin[1] = 0; always #3.7  clkin[1] = ~clkin[1]; // 135 MHz
    initial clkin[2] = 0; always #12.0 clkin[2] = ~clkin[2]; // 41.6 MHz
    initial clkin[3] = 0; always #2.0  clkin[3] = ~clkin[3]; // 250 MHz

    // --- DUT Instantiation ---
    la_vclkmux #(
        .N(N),
        .STAGES(STAGES)
    ) dut (
        .clkin(clkin),
        .nreset(nreset),
        .sel(sel),
        .clkout(clkout)
    );

    // --- Glitch Detection Logic ---
    // Monitors the time between transitions on clkout. Any pulse
    // narrower than the fastest input clock half-period (while nreset
    // is released) is treated as a glitch.
    realtime last_edge_time;
    realtime pulse_width;
    reg      glitch_detected;

    initial begin
        glitch_detected = 0;
        last_edge_time  = 0;
    end

    always @(clkout) begin
        if (last_edge_time > 0) begin
            pulse_width = $realtime - last_edge_time;
            if (pulse_width < 0.5 && nreset) begin
                $display("ERROR: Glitch detected at %t | Width: %0.3f ns",
                         $realtime, pulse_width);
                glitch_detected = 1;
            end
        end
        last_edge_time = $realtime;
    end

    // --- Stimulus ---
    // Exercises the documented usage contract: power-on nreset, then
    // switch clocks by pulsing sel==0 between one-hot selections.
    initial begin
        // Setup VCD dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_la_vclkmux);

        // Power-on initialization: assert nreset to bring up the
        // per-domain synchronizers, then release it.
        nreset = 0;
        sel    = 4'b0000;
        #50;
        nreset = 1;
        #100;  // allow rsync+drsync to come out of reset in every domain

        // Sequence 1: Select Clock 0 via the contract.
        $display("Switching to Clock 0 (sel==0 -> 0001)...");
        sel = 4'b0001;
        #300;

        // Sequence 2: Switch to Clock 2 (slowest) via a sel==0 pulse.
        // The zero pulse must be long enough for the deselected
        // channel's enable to fall through its drsync (>= STAGES cycles
        // of its clkin) before the new channel is selected.
        $display("Switching to Clock 2 (0001 -> 0000 -> 0100)...");
        sel = 4'b0000;
        #200;            // ample for 41.6 MHz domain (~24 ns period)
        sel = 4'b0100;
        #400;

        // Sequence 3: Switch to Clock 3 (fastest) via a sel==0 pulse.
        $display("Switching to Clock 3 (0100 -> 0000 -> 1000)...");
        sel = 4'b0000;
        #200;
        sel = 4'b1000;
        #300;

        // Sequence 4: Switch to Clock 1 via a sel==0 pulse.
        $display("Switching to Clock 1 (1000 -> 0000 -> 0010)...");
        sel = 4'b0000;
        #200;
        sel = 4'b0010;
        #300;

        // Final Check
        if (glitch_detected)
            $display("TEST FAILED: Glitches were observed.");
        else
            $display("TEST PASSED: Clean clock switching observed.");

        $finish;
    end

endmodule
