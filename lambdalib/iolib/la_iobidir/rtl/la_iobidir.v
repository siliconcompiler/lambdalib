/**************************************************************************
 * Function: Digital Bidirectional IO Buffer
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * ../README.md
 *
 *************************************************************************/
module la_iobidir
  #(
    parameter PROP = "DEFAULT", // cell property
    parameter SIDE = "NO",      // "NO", "SO", "EA", "WE"
    parameter CFGW = 16,        // width of tech specific config bus
    parameter RINGW = 8         // width of io ring
    )
   (// io pad signals
    inout             pad,     // bidirectional pad signal
    inout             vdd,     // core supply
    inout             vss,     // core ground
    inout             vddio,   // io supply
    inout             vssio,   // io ground
    // core facing signals
    input             a,       // input from core
    output            z,       // output to core
    input             ie,      // input enable, 1 = active
    input             oe,      // output enable, 1 = active
    input             pe,      // pull enable, 1 = enable
    input             ps,      // pull select, 1 = pullup, 0 = pulldown
    input             schmitt, // schmitt cfg, 1 = active
    input             fast,    // 1 = fast slew rate
    input [1:0]       ds,      // drive strength, 0=weakest
    inout [RINGW-1:0] ioring,  // generic io ring
    input [CFGW-1:0]  cfg      // generic config interface
    );

   assign pad = oe ? a : 1'bz;

`ifdef VERILATOR
   // Break bidirectional combinational loop for Verilator.
   // When OE active, input reads 0 (no self-loopback).
   // Sampling input while driving is not a recommended feature.
   // Use `a` signal before pad if you want that functionality.
   // Real pads have propagation delay that breaks the loop.
   assign z   = (ie & ~oe) ? pad : 1'b0;
`else
   assign z   = ie ? pad : 1'b0;
   rnmos #1 (pad, vssio, pe & ~ps); // weak pulldown
   rnmos #1 (pad, vddio, pe & ps); // weak pullup
`endif

endmodule

//######################################################################
// MINIMAL TESTBENCH
//######################################################################

`ifdef TB_LA_IOBIDIR

module tb();

   parameter CFGW = 16;
   parameter RINGW = 8;

   localparam PERIOD = 10;
   localparam TIMEOUT = PERIOD  * 200;

   reg        drive;
   reg        data;

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
        // inactive
        a = 1'bx;
        schmitt = 1'b0;
        fast = 1'b0;
        ds = 2'b0;
        ie = 1'b0;
        oe = 1'b0;
        pe = 1'b0;
        ps = 1'b0;
        cfg = 'b0;
        drive = 1'b0;
        data = 1'b0;
        // with pulldown
        #(PERIOD)
        pe = 1'b1;
        ps = 1'b0;
        // with pullup
        #(PERIOD)
        ps = 1'b1;
        // driven input with pullup
        #(PERIOD)
        ie = 1'b1;
        drive = 1'b1;
        data = 1'b0;
        #(PERIOD)
        data = 1'b1;
        // output
        #(PERIOD)
        drive = 1'b0;
        oe = 1'b1;
        a = 1'b0;
        #(PERIOD)
        a = 1'b1;
        // conflict
        drive = 1'b1;
        data = 1'b0;
     end

   assign vss   = 1'b0;
   assign vssio = 1'b0;
   assign vdd   = 1'b1;
   assign vddio = 1'b1;

   assign pad = drive ? data : 1'bz;

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  a;
   reg [CFGW-1:0]       cfg;
   reg [1:0]            ds;
   reg                  fast;
   reg                  ie;
   reg                  oe;
   reg                  pe;
   reg                  ps;
   reg                  schmitt;
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [RINGW-1:0]     ioring;
   wire                 pad;
   wire                 vdd;
   wire                 vddio;
   wire                 vss;
   wire                 vssio;
   wire                 z;
   // End of automatics

   la_iobidir
     la_iobidir(/*AUTOINST*/
                // Outputs
                .z              (z),
                // Inouts
                .pad            (pad),
                .vdd            (vdd),
                .vss            (vss),
                .vddio          (vddio),
                .vssio          (vssio),
                .ioring         (ioring[RINGW-1:0]),
                // Inputs
                .a              (a),
                .ie             (ie),
                .oe             (oe),
                .pe             (pe),
                .ps             (ps),
                .schmitt        (schmitt),
                .fast           (fast),
                .ds             (ds[1:0]),
                .cfg            (cfg[CFGW-1:0]));

endmodule
`endif
