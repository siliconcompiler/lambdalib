/*****************************************************************************
 * Function: Configurable Logic Block (N x blek4p0)
 * Copyright: Lambda Project Authors. All rights Reserved
 * License:  MIT (see LICENSE file in Lambda repository)
 *****************************************************************************
 *
 * Documentation:
 *
 * Testing:
 *
 * >> iverilog la_clbk4p0.v -DTB_LA_CLBK4P0 -y . -y ../stdlib/rtl
 * >> ./a.out
 * *
 ****************************************************************************/

module la_clbk4p0
  #(parameter PROP = "DEFAULT", // implementation selector
    parameter N = 8,            // number of BLEs
    parameter I = 8             // number of inputs
    )
   (// controls
    input            clk,    // free running clock
    input            nreset, // asynch active low reset
    input [8*16-1:0] cfglut, // lut cfg
    input [7:0]      cfgff,  // ble ff mux selector
    input [7:0]      cfgcb  // ble ff mux selector
    // data
    input [8*4-10]   in,     // logical inputs
    output [7:0]     out     // output
    );


   wire [3:0] crossbar[7:0];
   genvar     i,j;

   //TODO: example local crossbar
   for (i=0;i<8;i=i+1)
     for (j=0;j<4;j=j+1)
       begin

       end

   for (i=0;i<N;i=i+1)
     begin gble
       la_blek4p0 i0 (// Outputs
                      .out              (out[i]),
                      // Inputs
                      .in               (clbin[i*N+:N]),
                      .lut              (lut[i*N+:N]),
                      .sel              (cfg[i]),
                      .clk              (clk),
                      .nreset           (nreset));
     end


endmodule

`ifdef TB_LA_CLBK4P0

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
   la_clbk4p0
     la_clb (/*AUTOINST*/
             // Outputs
             .out               (out[7:0]),
             // Inputs
             .clk               (clk),
             .nreset            (nreset),
             .cfglut            (cfglut[8*16-1:0]),
             .cfgff             (cfgff[7:0]),
             .cfgcb             (cfgcb[7:0]),
             .in                (in[8*4-10]));

endmodule

`endif
