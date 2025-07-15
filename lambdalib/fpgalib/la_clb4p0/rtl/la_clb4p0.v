/*******************************************************************************
 * Function: Logic Block With Full Crossbar Local Interconnect (N x BLE4P0)
 * Copyright: Lambda Project Authors. All rights Reserved
 * License:  MIT (see LICENSE file in Lambda repository)
 *******************************************************************************
 *
 * Documentation:
 *
 * This logic block includes "N" BLEs and a full crossbar
 * between CLB inputs, BLE outputs and each of the LUT inputs.
 *
 * Feedback from BLE output back to the inputs of the same BLE is done
 * using the q output to avoid combinational feedback loops.
 *
 * The maximum number of inputs is N x 4, used for config bits.
 *
 * LUT outputs are the fast feedback paths.
 *
 * Build/Run:
 *
 * >> iverilog la_clb4p0.v -DTB_LA_CLB4P0 -y . -y ../../stdlib/rtl
 * >> ./a.out
 *
 * Test:
 *
 * 1. N=2, I=4
 * 2. test1: CLB configured as separate and4, or4 gates
 * 3. test2" LB configured as combined and7 (in[7]=ignored)
 *
 ******************************************************************************/

module la_clb4p0
  #(parameter PROP = "DEFAULT", // implementation selector
    parameter N = 1,            // number of BLEs
    parameter I = 8,            // number of inputs (<=N*K)
    parameter K = 4,            // LUT size (fixed!)
    parameter CB = 1            // 0 disables crossbar
    )
   (// logic
    input                     clk, // free running clock
    input                     nreset, // asynch active low reset
    input [I-1:0]             in, // logical inputs
    output [N-1:0]            out, // output
    // configuration bits
    input [N*(2**K)-1:0]      cfglut, // lut
    input [N-1:0]             cfgbp, // bypass mux
    input [N*K*$clog2(I)-1:0] cfgin, // input mux
    input [N*K*$clog2(N)-1:0] cfgfb, // feedback mux
    input [N*K-1:0]           cfgloc // local select mux
    );

   // wires
   wire [N-1:0]               q;
   wire [N-1:0]               fb[N-1:0];
   wire [K-1:0]               inmux[N-1:0];
   wire [K-1:0]               fbmux[N-1:0];
   wire [K-1:0]               lutmux[N-1:0];
   genvar                     i,j;

   // full crossbar from all clb inputs to all lut inputs
   for (i=0;i<N;i=i+1)
     for (j=0;j<K;j=j+1)
       begin: ginput
          assign inmux[i][j] = in[cfgin[(i*K+j)*$clog2(I)+:$clog2(I)]];
       end

   // feedback reg output for same lut (no loops!)
   for (i=0;i<N;i=i+1)
     begin: gnocombo
        for (j=0;j<N;j=j+1)
          if (i==j)
            assign fb[i][j] = q[j];
          else
            assign fb[i][j] = out[j];
     end

   // feedback mux
   for (i=0;i<N;i=i+1)
     begin: gfb
        for (j=0;j<K;j=j+1)
          if (N>1)
            assign fbmux[i][j] = fb[i][cfgfb[(i*K+j)*$clog2(N)+:$clog2(N)]];
          else
            assign fbmux[i][j] = fb[i][j];
     end

   // select between feedback and primary inputs
   for (i=0;i<N;i=i+1)
     begin: gsel
        for (j=0;j<K;j=j+1)
          if (CB)
            assign lutmux[i][j] = cfgloc[i*K+j] ? fbmux[i][j] : inmux[i][j];
          else
            assign lutmux[i][j] = in[i*K+j];
     end

   // BLE instantiation
   for (i=0;i<N;i=i+1)
     begin: gble
        la_ble4p0 i0 (// Outputs
                      .out       (out[i]),
                      .q         (q[i]),
                      // config
                      .cfglut    (cfglut[i*16+:16]),
                      .cfgbp     (cfgbp[i]),
                      // Inputs
                      .in        (lutmux[i]),
                      .clk       (clk),
                      .nreset    (nreset));
     end

endmodule

`ifdef TB_LA_CLB4P0
module tb();

   localparam N = 2;
   localparam K = 4;
   localparam I = 8;

   localparam PERIOD = 2;
   localparam TIMEOUT = PERIOD * 512;

   reg                     clk;
   reg                     nreset;
   reg [I-1:0]             in;
   reg [N*(2**K)-1:0]      cfglut; // lut
   reg [N-1:0]             cfgbp; // reg mux
   reg [N*K*$clog2(I)-1:0] cfgin; // input mux
   reg [N*K*$clog2(N)-1:0] cfgfb; // feedback mux
   reg [N*K-1:0]           cfgloc; // local select mux

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [N-1:0]            out;
   // End of automatics

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
        cfgbp = 2'b11;
        #(1)
        nreset = 'b1;
        $display("----AND4, OR4 ----");
        cfglut = 32'hFFFE_8000;                       // and/or
        cfgin  = 24'b111_110_101_100_011_010_001_000; // straight
        cfgfb  = 24'b000_000_000_000_000_000_000_000; // dont care
        cfgloc =  8'b0000_0000;
        #(PERIOD * 32)
        $display("---- 1 x AND7 ----");
        cfglut = 32'h8000_8000;                       // and gate
        cfgin  = 24'b111_110_101_100_011_010_001_000; // i[7:4]=i[3:0]
        cfgfb  = 24'b000_000_000_000_000_000_000_000; // feedback
        cfgloc =  8'b1000_0000;
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
       if (out)
         $display("lut=%h, sel=%b, in=%b, out=%b", cfglut, cfgbp, in, out);

   // dut
   la_clb4p0 # (.I(I),.N(N), .K(K))
   la_clb (/*AUTOINST*/
           // Outputs
           .out                         (out[N-1:0]),
           // Inputs
           .clk                         (clk),
           .nreset                      (nreset),
           .in                          (in[I-1:0]),
           .cfglut                      (cfglut[N*(2**K)-1:0]),
           .cfgbp                       (cfgbp[N-1:0]),
           .cfgin                       (cfgin[N*K*$clog2(I)-1:0]),
           .cfgfb                       (cfgfb[N*K*$clog2(N)-1:0]),
           .cfgloc                      (cfgloc[N*K-1:0]));


   // icarus workaround
   integer k;
   initial
     begin
        for (k = 0; k <N; k = k + 1)
          begin
             $dumpvars(0,la_clb.inmux[k]);
             $dumpvars(0,la_clb.fb[k]);
             $dumpvars(0,la_clb.fbmux[k]);
             $dumpvars(0,la_clb.lutmux[k]);
          end
     end

endmodule

`endif
