/*****************************************************************************
 * Function: Configurable Logic Block (8 x BLEs(LUT4), Part0)
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *****************************************************************************
 *
 * Documentation:
 *
 * Configurable logic block with 8 LUT4 based BLEs.
 *
 * Testing:
 *
 * >> iverilog la_clbk4n8p0.v -DTB_LA_CLBK4N8P0 -y . -y ../stdlib/rtl
 * >> ./a.out
 * *
 ****************************************************************************/

module la_clbk4n8p0
  #(parameter TYPE  = "DEFAULT" //  implementation selector
    )
   (
    input [3:0]  in,
    input [15:0] lut,
    input        sel, // 1 = with register, 0 = bypass register
    input        clk,
    input        nreset,
    output       out
    );


   la_blek4p0 ble (/*AUTOINST*/);



endmodule

`ifdef TB_LA_CLB4KN8P0

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
   la_ble4p0
     la_ble (/*AUTOINST*/);

endmodule

`endif
