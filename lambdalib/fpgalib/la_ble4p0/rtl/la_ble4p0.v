/*****************************************************************************
 * Function: Basic Logic Element (LUT4, Part#0)
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *****************************************************************************
 *
 * Documentation:
 *
 * Basic FPGA logic element consisting of LUT4, a flip-flop with async reset,
 * and mux.
 *
 * Testing:
 *
 * >> iverilog la_ble4p0.v -DTB_LA_BLE4P0 -y . -y ../../stdlib/rtl
 * >> ./a.out
 *
 *
 ****************************************************************************/

module la_ble4p0
  #(parameter PROP  = "DEFAULT" //  implementation selector
    )
   (// logic
    input        clk, // clock
    input        nreset,// async active low reset
    input [3:0]  in, // input
    output       q, // reg output
    output       out, // mux output
    //config
    input [15:0] cfglut,// lookup table
    input        cfgbp // 1: bypass register
    );

   wire          lutout;

   la_lut4  ilut(.out(lutout), .in (in[3:0]), .lut(cfglut[15:0]));
   la_dffrq idff(.q(q), .d(lutout), .clk(clk), .nreset(nreset));
   la_mux2  imux(.z(out), .d0(q), .d1(lutout), .s(cfgbp));

endmodule

`ifdef TB_LA_BLE4P0

module tb();

   localparam PERIOD = 2;
   localparam TIMEOUT = PERIOD * 33;

   reg        clk;
   reg        nreset;
   reg [3:0]  in;
   reg [15:0] cfglut;
   reg        cfgbp;
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
        cfgbp = 1'b1;
        #(1)
        $display("---- AND GATE ----");
        nreset = 'b1;
        cfglut = 16'h8000; // 4 input and gate
        #(PERIOD * 16)
        $display("---- OR GATE ----");
        cfglut = 16'hFFFE; // 4 input or gate
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
       $display("lut=%h, sel=%b, in=%b, out=%b, q=%b", cfglut, cfgbp, in, out, q);

   // dut
   la_ble4p0
     la_ble (/*AUTOINST*/
             // Outputs
             .q                 (q),
             .out               (out),
             // Inputs
             .clk               (clk),
             .nreset            (nreset),
             .in                (in[3:0]),
             .cfglut            (cfglut[15:0]),
             .cfgbp             (cfgbp));

endmodule

`endif
