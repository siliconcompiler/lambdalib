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

    // --- Phase-Equality Detector ---
    // Measures high and low pulse widths on clkout and on each
    // clkin[i] independently, then compares clkout's widths against
    // the selected clkin[i]'s widths. Because each width is captured
    // within its own signal's active region (timestamp at posedge
    // and at negedge of that signal), there is no cross-signal
    // delta-cycle race.
    realtime clkout_pos_t,  clkout_neg_t;
    realtime clkout_high_w, clkout_low_w;
    realtime clkin_pos_t  [0:N-1];
    realtime clkin_neg_t  [0:N-1];
    realtime clkin_high_w [0:N-1];
    realtime clkin_low_w  [0:N-1];

    realtime settled_until;

    // Tolerance for floating-point pulse-width comparison. Real
    // hardware delays we care about are >> 1 ps; anything within 1 ps
    // is sim noise (realtime accumulation drift on irrational delays
    // like the 3.7 ns half-period).
    localparam real TOL_NS = 0.001;
    reg      phase_mismatch;
    integer  phase_mismatch_count;
    integer  k;

    initial begin
        settled_until        = 0;
        phase_mismatch       = 0;
        phase_mismatch_count = 0;
        clkout_pos_t         = 0;
        clkout_neg_t         = 0;
        clkout_high_w        = 0;
        clkout_low_w         = 0;
        for (k = 0; k < N; k = k + 1) begin
            clkin_pos_t[k]  = 0;
            clkin_neg_t[k]  = 0;
            clkin_high_w[k] = 0;
            clkin_low_w[k]  = 0;
        end
    end

    // Reopen the settling window on any sel or nreset transition.
    // 200 ns covers STAGES=2 of the slowest clock (12 ns half-period)
    // through both the drsync chain and the ICG latch capture.
    always @(sel or nreset) begin
        settled_until = $realtime + 200;
    end

    // Timestamp clkout edges and compute its pulse widths.
    always @(posedge clkout) begin
        clkout_pos_t = $realtime;
        if (clkout_neg_t > 0)
          clkout_low_w = clkout_pos_t - clkout_neg_t;
    end
    always @(negedge clkout) begin
        clkout_neg_t = $realtime;
        if (clkout_pos_t > 0)
          clkout_high_w = clkout_neg_t - clkout_pos_t;
    end

    // Timestamp each clkin[i] edge and compute its pulse widths.
    genvar g;
    generate
        for (g = 0; g < N; g = g + 1) begin : pwm
            always @(posedge clkin[g]) begin
                clkin_pos_t[g] = $realtime;
                if (clkin_neg_t[g] > 0)
                  clkin_low_w[g] = clkin_pos_t[g] - clkin_neg_t[g];
            end
            always @(negedge clkin[g]) begin
                clkin_neg_t[g] = $realtime;
                if (clkin_pos_t[g] > 0)
                  clkin_high_w[g] = clkin_neg_t[g] - clkin_pos_t[g];
            end
        end
    endgenerate

    // On each completed clkout cycle, compare clkout's high/low widths
    // against the selected clkin[i]'s most recent widths. Comparison
    // is within TOL_NS to absorb realtime FP drift on irrational
    // half-periods (e.g. 3.7 ns).
    real hi_err, lo_err;
    always @(posedge clkout) begin
        if (nreset && ($realtime >= settled_until) && (sel != 0)
            && (clkout_high_w > 0) && (clkout_low_w > 0)) begin
            for (k = 0; k < N; k = k + 1) begin
                if (sel[k] && (clkin_high_w[k] > 0) && (clkin_low_w[k] > 0)) begin
                    hi_err = clkout_high_w - clkin_high_w[k];
                    lo_err = clkout_low_w  - clkin_low_w[k];
                    if (hi_err < 0) hi_err = -hi_err;
                    if (lo_err < 0) lo_err = -lo_err;
                    if ((hi_err > TOL_NS) || (lo_err > TOL_NS)) begin
                        $display("ERROR: Pulse-width mismatch at %t | sel=%b clkout hi=%0.3f lo=%0.3f vs clkin[%0d] hi=%0.3f lo=%0.3f (ns)",
                                 $realtime, sel,
                                 clkout_high_w, clkout_low_w,
                                 k, clkin_high_w[k], clkin_low_w[k]);
                        phase_mismatch       = 1;
                        phase_mismatch_count = phase_mismatch_count + 1;
                    end
                end
            end
        end
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
        if (glitch_detected || phase_mismatch)
            $display("TEST FAILED: %0sglitch=%0d phase_mismatches=%0d",
                     "", glitch_detected, phase_mismatch_count);
        else
            $display("TEST PASSED: Clean clock switching and phase match observed.");

        $finish;
    end

endmodule
