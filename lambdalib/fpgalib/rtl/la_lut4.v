/*****************************************************************************
 * Function: 4-Bit Look-Up-Table
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *****************************************************************************
 *
 * Documentation:
 *

 * i[3]	i[2]	i[1]	i[0]	out
 * -------------------------------------
 * 0	0	0	0	lut[0]
 * 0	0	0	1	lut[1]
 * 0	0	1	0	lut[2]
 * 0	0	1	1	lut[3]
 * 0	1	0	0	lut[4]
 * 0	1	0	1	lut[5]
 * 0	1	1	0	lut[6]
 * 0	1	1	1	lut[7]
 * 1	0	0	0	lut[8]
 * 1	0	0	1	lut[9]
 * 1	0	1	0	lut[10]
 * 1	0	1	1	lut[11]
 * 1	1	0	0	lut[12]
 * 1	1	0	1	lut[13]
 * 1	1	1	0	lut[14]
 * 1	1	1	1	lut[15]
 *
 *
 * Testing:
 *
 * >> iverilog lat_lut4.v -DTB_LA_LUT4 -y . -y ../stdlib/rtl
 * >> ./a.out
 *
 *
 ****************************************************************************/

module la_lut4
  #(parameter TYPE  = "DEFAULT" //  implementation selector
    )
   (input [3:0]  in,
    input [15:0] lut,
    output       out
    );

   wire [7:0] int0;
   wire [3:0] int1;
   wire [1:0] int2;

   // 16:8
   la_mux2 m0_0 (.d0(lut[0]),  .d1(lut[1]),  .s(in[0]), .z(int0[0]));
   la_mux2 m0_1 (.d0(lut[2]),  .d1(lut[3]),  .s(in[0]), .z(int0[1]));
   la_mux2 m0_2 (.d0(lut[4]),  .d1(lut[5]),  .s(in[0]), .z(int0[2]));
   la_mux2 m0_3 (.d0(lut[6]),  .d1(lut[7]),  .s(in[0]), .z(int0[3]));
   la_mux2 m0_4 (.d0(lut[8]),  .d1(lut[9]),  .s(in[0]), .z(int0[4]));
   la_mux2 m0_5 (.d0(lut[10]), .d1(lut[11]), .s(in[0]), .z(int0[5]));
   la_mux2 m0_6 (.d0(lut[12]), .d1(lut[13]), .s(in[0]), .z(int0[6]));
   la_mux2 m0_7 (.d0(lut[14]), .d1(lut[15]), .s(in[0]), .z(int0[7]));

   // 8:4
   la_mux2 m1_0 (.d0(int0[0]), .d1(int0[1]),  .s(in[1]), .z(int1[0]));
   la_mux2 m1_1 (.d0(int0[2]), .d1(int0[3]),  .s(in[1]), .z(int1[1]));
   la_mux2 m1_2 (.d0(int0[4]), .d1(int0[5]),  .s(in[1]), .z(int1[2]));
   la_mux2 m1_3 (.d0(int0[5]), .d1(int0[7]),  .s(in[1]), .z(int1[3]));

   // 4:2
   la_mux2 m2_0 (.d0(int1[0]), .d1(int1[1]),  .s(in[2]), .z(int2[0]));
   la_mux2 m2_1 (.d0(int1[2]), .d1(int1[3]),  .s(in[2]), .z(int2[1]));

   // 2:1
   la_mux2 m3_1 (.d0(int2[0]), .d1(int2[1]),  .s(in[3]), .z(out));


endmodule


`ifdef TB_LA_LUT4

module tb();

   localparam TIMEOUT = 100;
   localparam PERIOD = 2;

   reg        clk;
   reg        nreset;
   reg [3:0]  in;
   reg [15:0] lut;
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
        #(1)
        nreset = 'b1;
	lut = 16'h8000; // 4 input and gate
        #(PERIOD * 25)
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
       $display("lut=%h, in=%b, out=%b", lut, in, out);


   // dut
   la_lut4
     la_lut4 (/*AUTOINST*/
              // Outputs
              .out              (out),
              // Inputs
              .in               (in[3:0]),
              .lut              (lut[15:0]));

endmodule

`endif
