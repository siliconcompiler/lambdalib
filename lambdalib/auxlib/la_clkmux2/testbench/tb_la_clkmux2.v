module tb_la_clkmux2();
   reg clk0, clk1, sel, nreset;
   wire out;

   // Clock definitions
   initial clk0 = 0; always #5 clk0 = ~clk0; // 100MHz
   initial clk1 = 0; always #2 clk1 = ~clk1; // 250MHz

   la_clkmux2 dut (.clk0(clk0), .clk1(clk1), .sel(sel), .nreset(nreset), .out(out));

   // Watchdog Timer: Stop the simulation if it hangs
   initial begin
      #1000;
      $display("Simulation Timeout! Check if clocks are toggling.");
      $finish;
   end

   initial begin
      // Setup VCD dumping
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_la_clkmux2);

      // reset
      nreset = 0; sel = 0;
      #20 nreset = 1;

      // Wait for synchronization (usually 2-3 cycles of clk0)
      #107;
      sel = 1; // Switch to clk1
      #237;
      sel = 0; // Switch back to clk0
      #100;
      $display("Test Finished Successfully");
      $finish;
   end
endmodule
