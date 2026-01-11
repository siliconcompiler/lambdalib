`timescale 1ns/1ps

module tb_la_oddr();

    // Verilog-2005 String storage (8 bits per character)
    reg [47:0] prop_str;

    // Inputs
    reg clk;
    reg [1:0] mode;
    reg in0;
    reg in1;

    // Output
    wire out;

    // Instantiate the Unit Under Test (UUT)
    la_oddr uut (
        .clk(clk),
        .mode(mode),
        .in0(in0),
        .in1(in1),
        .out(out)
    );

    // Parameter override using Verilog-2005 defparam
    defparam uut.PROP = "LATCH";

    // Clock Generation (100 MHz / 10ns Period)
    initial begin
        clk = 0;
    end
    always begin
        #5 clk = ~clk;
    end

    // Waveform Dump Configuration
    initial begin
        $dumpfile("waveform.vcd"); // Name of the output file
        $dumpvars(0, tb_la_oddr);  // Dump all signals in tb and sub-modules
    end

    // Test Procedure
    initial begin
        // Initialize
        prop_str = "LATCH";
        mode = 0;
        in0  = 0;
        in1  = 0;

        $display("Starting ODDR Verification (PROP=%s)...", prop_str);

        // Monitoring to console
        $monitor("Time=%0t | Mode=%0d | In0=%b In1=%b | Out=%b", $time, mode, in0, in1, out);

        // --- Mode 0: Bypass ---
        $display("\nTesting Mode 0: Bypass (SDR Mode)");
        mode = 0;
        @(posedge clk);
        in0 = 1; in1 = 0;
        #2; if (out !== 1) $display("Error: Bypass failed at T=%0t", $time);

        @(posedge clk);
        in0 = 0; in1 = 1;
        #2; if (out !== 0) $display("Error: Bypass failed at T=%0t", $time);

        // --- Mode 1: Opposite-Edge ---
        $display("\nTesting Mode 1: Opposite-Edge");
        mode = 1;
        // Bit 0 at Rise, Bit 1 at Fall
        @(posedge clk);
        in0 = 1; in1 = 0;
        #2; if (out !== 1) $display("Error: Mode 1 Rise phase failed");

        @(negedge clk);
        in1 = 1; // Change in1 to be sampled at falling edge
        #2; if (out !== 1) $display("Error: Mode 1 Fall phase failed");

        // --- Mode 2: Same-Edge ---
        $display("\nTesting Mode 2: Same-Edge");
        mode = 2;
        // Both bits provided at the same Rising Edge
        @(posedge clk);
        in0 = 0;
        in1 = 1;
        #2; // Check High phase (should be in0)
        if (out !== 0) $display("Error: Mode 2 Rise phase failed");
        #5; // Check Low phase (should be in1)
        if (out !== 1) $display("Error: Mode 2 Fall phase failed");

        @(posedge clk);
        in0 = 1;
        in1 = 0;
        #2; if (out !== 1) $display("Error: Mode 2 Rise phase failed");
        #5; if (out !== 0) $display("Error: Mode 2 Fall phase failed");

        #20;
        $display("\nVerification Complete. Waveform dumped to waveform.vcd");
        $finish;
    end

endmodule
