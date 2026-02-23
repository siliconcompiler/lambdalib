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
    // Monitors the time between transitions on clkout
    realtime last_edge_time;
    realtime pulse_width;
    reg glitch_detected;

    initial begin
        glitch_detected = 0;
        last_edge_time = 0;
    end

    always @(clkout) begin
        if (last_edge_time > 0) begin
            pulse_width = $realtime - last_edge_time;
            // Define glitch: any pulse < 1ns (shorter than our fastest half-period)
            // unless we are in the middle of a reset transition.
            if (pulse_width < 0.5 && nreset) begin
                $display("ERROR: Glitch detected at %t | Width: %0.3f ns", $realtime, pulse_width);
                glitch_detected = 1;
            end
        end
        last_edge_time = $realtime;
    end

    // --- Stimulus ---
    initial begin
        // Setup VCD dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_la_vclkmux);

        // Initialize
        nreset = 0;      // Start in reset (Quiet)
        sel    = 4'b0001; // Select Clock 0

        #50;

        // Sequence 1: Enable Clock 0
        $display("Switching to Clock 0...");
        nreset = 1;
        #200;

        // Sequence 2: Switch to Clock 2 (Much Slower)
        $display("Switching to Clock 2 (Quiet Path)...");
        nreset = 0;       // 1. Assert nreset
        #33.3;            // Wait some "random" time
        sel = 4'b0100;    // 2. Change Selection
        #50.7;            // Wait some "random" time
        nreset = 1;       // 3. Release nreset
        #400;

        // Sequence 3: Switch to Clock 3 (Fastest) while clocks are running
        $display("Switching to Clock 3...");
        nreset = 0;
        #15;
        sel = 4'b1000;
        #15;
        nreset = 1;
        #200;

        // Final Check
        if (glitch_detected)
            $display("TEST FAILED: Glitches were observed.");
        else
            $display("TEST PASSED: Clean clock switching observed.");

        $finish;
    end

endmodule
