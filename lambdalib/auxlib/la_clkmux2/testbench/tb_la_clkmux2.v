module tb_la_clkmux2();
   reg clk0, clk1, sel, nreset;
   reg clk1_en;
   wire out;

   // Clock definitions
   initial clk0 = 0; always #20 clk0 = ~clk0; // 25MHz
   initial begin clk1 = 0; clk1_en = 0; end
   always #2 if (clk1_en) clk1 = ~clk1;

   la_clkmux2 dut (.clk0(clk0), .clk1(clk1), .nreset(nreset), .sel(sel), .out(out));

   // Watchdog Timer
   initial begin
      #10000;
      $display("FAIL: Simulation Timeout!");
      $finish;
   end

   // Edge counter for output
   integer out_edges;
   initial out_edges = 0;
   always @(posedge out) out_edges <= out_edges + 1;

   // Helper task: check output is toggling
   task check_toggling;
      input [80*8-1:0] label;
      begin
         out_edges = 0;
         #200;
         if (out_edges == 0) begin
            $display("FAIL: %0s", label);
            $finish;
         end
         $display("PASS: %0s (%0d edges)", label, out_edges);
      end
   endtask

   initial begin
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_la_clkmux2);

      // ----------------------------------------------------------
      // 1. Reset: clk0 propagates, clk1 off
      // ----------------------------------------------------------
      sel    = 0;
      nreset = 0;
      check_toggling("clk0 during reset");

      // ----------------------------------------------------------
      // 2. Release reset, start clk1
      // ----------------------------------------------------------
      @(negedge clk0);
      nreset = 1;
      clk1_en = 1;
      check_toggling("clk0 after reset, clk1 running");

      // ----------------------------------------------------------
      // sel transitions with clk1 running
      // ----------------------------------------------------------

      // 3. sel 0->1, clk1 running
      sel = 1;
      #100;
      check_toggling("sel 0->1, clk1 running");

      // 4. sel 1->0, clk1 running
      sel = 0;
      #100;
      check_toggling("sel 1->0, clk1 running");

      // ----------------------------------------------------------
      // sel transitions with clk1 stopped
      // ----------------------------------------------------------

      // 5. sel 0->1 with clk1 stopped (output should stop)
      clk1_en = 0;
      clk1    = 0;
      #50;
      sel = 1;
      #100;
      out_edges = 0;
      #200;
      $display("INFO: sel 0->1, clk1 stopped (%0d edges, expect 0)", out_edges);

      // 6. sel 1->0 with clk1 stopped, then restart clk1
      sel = 0;
      #100;
      clk1_en = 1;
      check_toggling("sel 1->0, clk1 stopped then restarted");

      // ----------------------------------------------------------
      // sel already at target with clk1 stop/start
      // ----------------------------------------------------------

      // 7. sel=0 throughout, stop and restart clk1
      clk1_en = 0;
      clk1    = 0;
      #100;
      check_toggling("sel=0, clk1 stopped (clk0 unaffected)");
      clk1_en = 1;
      #50;

      // 8. Switch to clk1, stop it, restart it
      sel = 1;
      #100;
      check_toggling("sel=1, clk1 running");
      clk1_en = 0;
      clk1    = 0;
      #100;
      clk1_en = 1;
      check_toggling("sel=1, clk1 stopped then restarted");

      // ----------------------------------------------------------
      // Final: back to clk0
      // ----------------------------------------------------------
      sel = 0;
      #100;
      check_toggling("final sel=0, both clocks running");

      $display("Test Finished Successfully");
      $finish;
   end
endmodule
