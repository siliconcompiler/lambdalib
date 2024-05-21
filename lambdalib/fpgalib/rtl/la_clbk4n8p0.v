/*****************************************************************************
 * Function: Configurable Logic Block (8 x blek4p0)
 * Copyright: Lambda Project Authors. All rights Reserved
 * License:  MIT (see LICENSE file in Lambda repository)
 *****************************************************************************
 *
 * Documentation:
 *
 * Testing:
 *
 * >> iverilog la_clbk4n8p0.v -DTB_LA_CLBK4N8P0 -y . -y ../stdlib/rtl
 * >> ./a.out
 * *
 ****************************************************************************/

module la_clbk4n8p0
  #(parameter PROP = "DEFAULT", //  implementation selector
    parameter N = 8
    )
   (
    input [N*4-10]   in,
    input [N*16-1:0] lut,
    input [N-1:0]    sel, // 1 = with register, 0 = bypass register
    input            clk,
    input            nreset,
    output [N-1:0]   out
    );


   wire [4*N-1:0] clbin;

   //TODO: example local crossbar



   genvar i;
   for (i=0:i<N;i=i+1)
     begin gble
       la_blek4p0 i0 (// Outputs
                      .out              (out[i]),
                      // Inputs
                      .in               (clbin[i*N+:N]),
                      .lut              (lut[i*N+:N]),
                      .sel              (sel[i]),
                      .clk              (clk),
                      .nreset           (nreset));
     end


endmodule

`ifdef TB_LA_CLBK4N8P0

module tb();

   localparam TIMEOUT = 100;
   localparam PERIOD = 2;

   reg        clk;
   reg        nreset;
   reg [3:0]  in;
   reg [15:0] lut;
   reg        sel;
   wire       out;

   // control block
   initial
     begin
        $timeformat(-9, 0, " ns", 20);
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
	#(TIMEOUT)
        $finish;
     end

  // test program
   initial
     begin
	#(1)
        nreset = 'b0;
        clk = 'b0;
        sel = 1'b0;
        #(1)
        nreset = 'b1;
	lut = 16'h8000; // 4 input and gate
        #(PERIOD * 25)
        sel = 1'b1;
        lut = 16'hFFFE; // 4 input or gate
     end

   // clk
   always
     #(PERIOD/2) clk = ~clk;

   // counter to cycle through stimulus
   always @ (posedge clk or negedge nreset)
     if (~nreset)
       in <= 'b0;
     else
       in <= in + 1'b1;


   always @ (posedge clk)
     if (nreset)
       $display("lut=%h, sel=%b, in=%b, out=%b", lut, sel, in, out);

   // dut
   la_clbk4n8p0
     la_clb (/*AUTOINST*/
             // Outputs
             .out               (out[N-1:0]),
             // Inputs
             .in                (in[N*4-10]),
             .lut               (lut[N*16-1:0]),
             .sel               (sel[N-1:0]),
             .clk               (clk),
             .nreset            (nreset));

endmodule

`endif
