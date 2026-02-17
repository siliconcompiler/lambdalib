module tb_la_clkdiv2();
   reg clk0, nreset;
   wire clk;
   wire clk90;

   // Clock definitions
   initial clk0 = 0; always #5 clk0 = ~clk0; // 100MHz

   la_clkdiv2 dut (.clkin(clk0), .nreset(nreset), .clk(clk), .clk90(clk90));

   // Watchdog Timer: Stop the simulation if it hangs
   initial begin
      #1000;
      $display("Simulation Timeout! Check if clocks are toggling.");
      $finish;
   end

   initial begin
      // Setup VCD dumping
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_la_clkdiv2);
      // startup
      nreset = 0;
      // Wait for synchronization (usually 2-3 cycles of clk0)
      #107;
      nreset = 1; // Switch to clk1
      #300;
      $display("Test Finished Successfully");
      $finish;
   end
endmodule
