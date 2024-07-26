/*****************************************************************************
 * Function: Padring Generator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Documentation:
 *
 * - see "../README.md"
 *
 * - Cround (vss) is continuous around the while chip.
 *
 * - Default is for ioring to be cut at corners, user must short rings
 *   at top level in RTl/netlist if abutted ring extends across corners.
 *
 * - CELLMAP = {SECTION#, PROP, CELL, PIN#}
 *
 * - SECTION specifies which power domain the pin belongs to
 *
 * - PIN maps the cell to the pin number
 *
 * - CELLTYPE[3:0] specifies the cell type (see la_iopadring.vh)
 *
 * - CELLTYPE[7:4] is used by inside lambda cells for selection
 *
 * Testing:
 *
 * >> iverilog la_iopadring.v -DTB_LA_IOPADRING -y . -y ../../iolib/rtl
 * >> ./a.out
 *
 *
 ****************************************************************************/

module la_iopadring
  #(
    parameter CFGW = 8,         // width of config bus
    parameter RINGW = 8,        // width of io ring
    parameter NO_NPINS = 1,     // IO pins per side
    parameter NO_NCELLS = 1,    // cells per side
    parameter NO_NSECTIONS = 1, // sections per side
    parameter NO_CELLMAP = 0,   // cell configuration (see above)
    parameter EA_NPINS = 1,
    parameter EA_NCELLS = 1,
    parameter EA_NSECTIONS = 1,
    parameter EA_CELLMAP = 0,
    parameter SO_NPINS = 1,
    parameter SO_NCELLS = 1,
    parameter SO_NSECTIONS = 1,
    parameter SO_CELLMAP = 0,
    parameter WE_NPINS = 1,
    parameter WE_NCELLS = 1,
    parameter WE_NSECTIONS = 1,
    parameter WE_CELLMAP = 0
    )
   (// CONTINUOUS GROUND
    inout                          vss,
    // NORTH
    inout [NO_NPINS-1:0]           no_pad,    // pad
    inout [NO_NPINS*3-1:0]         no_aio,    // analog inout
    output [NO_NPINS-1:0]          no_zp,     // output to core (positive)
    output [NO_NPINS-1:0]          no_zn,     // output to core (negative)
    input [NO_NPINS-1:0]           no_a,      // input from core
    input [NO_NPINS-1:0]           no_ie,     // input enable, 1 = active
    input [NO_NPINS-1:0]           no_oe,     // output enable, 1 = active
    input [NO_NPINS*CFGW-1:0]      no_cfg,    // generic config interface
    inout [NO_NSECTIONS-1:0]       no_vdd,    // core supply
    inout [NO_NSECTIONS-1:0]       no_vddio,  // io/analog supply
    inout [NO_NSECTIONS-1:0]       no_vssio,  // io/analog ground
    inout [NO_NSECTIONS*RINGW-1:0] no_ioring, // io ring
    // EAST
    inout [EA_NPINS-1:0]           ea_pad,
    inout [EA_NPINS*3-1:0]         ea_aio,
    output [EA_NPINS-1:0]          ea_zp,
    output [EA_NPINS-1:0]          ea_zn,
    input [EA_NPINS-1:0]           ea_a,
    input [EA_NPINS-1:0]           ea_ie,
    input [EA_NPINS-1:0]           ea_oe,
    input [EA_NPINS*CFGW-1:0]      ea_cfg,
    inout [EA_NSECTIONS-1:0]       ea_vdd,
    inout [EA_NSECTIONS-1:0]       ea_vddio,
    inout [EA_NSECTIONS-1:0]       ea_vssio,
    inout [EA_NSECTIONS*RINGW-1:0] ea_ioring,
    // SOUTH
    inout [SO_NPINS-1:0]           so_pad,
    inout [SO_NPINS*3-1:0]         so_aio,
    output [SO_NPINS-1:0]          so_zp,
    output [SO_NPINS-1:0]          so_zn,
    input [SO_NPINS-1:0]           so_a,
    input [SO_NPINS-1:0]           so_ie,
    input [SO_NPINS-1:0]           so_oe,
    input [SO_NPINS*CFGW-1:0]      so_cfg,
    inout [SO_NSECTIONS-1:0]       so_vdd,
    inout [SO_NSECTIONS-1:0]       so_vddio,
    inout [SO_NSECTIONS-1:0]       so_vssio,
    inout [SO_NSECTIONS*RINGW-1:0] so_ioring,
    // WEST
    inout [WE_NPINS-1:0]           we_pad,
    inout [WE_NPINS*3-1:0]         we_aio,
    output [WE_NPINS-1:0]          we_zp,
    output [WE_NPINS-1:0]          we_zn,
    input [WE_NPINS-1:0]           we_a,
    input [WE_NPINS-1:0]           we_ie,
    input [WE_NPINS-1:0]           we_oe,
    input [WE_NPINS*CFGW-1:0]      we_cfg,
    inout [WE_NSECTIONS-1:0]       we_vdd,
    inout [WE_NSECTIONS-1:0]       we_vddio,
    inout [WE_NSECTIONS-1:0]       we_vssio,
    inout [WE_NSECTIONS*RINGW-1:0] we_ioring
    );

`include "la_iopadring.vh"

   // NORTH
   la_ioside #(.SIDE("NO"),
               .NPINS(NO_NPINS),
               .NCELLS(NO_NCELLS),
               .NSECTIONS(NO_NSECTIONS),
               .CELLMAP(NO_CELLMAP),
               .RINGW(RINGW),
               .CFGW(CFGW))
   inorth (// Outputs
           .zp     (no_zp),
           .zn     (no_zn),
           // Inouts
           .pad    (no_pad),
           .aio    (no_aio),
           .vss    (vss),
           .vdd    (no_vdd),
           .vddio  (no_vddio),
           .vssio  (no_vssio),
           .ioring (no_ioring),
           // Inputs
           .a      (no_a),
           .ie     (no_ie),
           .oe     (no_oe),
           .cfg    (no_cfg));

   // EAST
   la_ioside #(.SIDE("EA"),
                .NPINS(EA_NPINS),
                .NCELLS(EA_NCELLS),
                .NSECTIONS(EA_NSECTIONS),
                .CELLMAP(EA_CELLMAP),
                .RINGW(RINGW),
                .CFGW(CFGW))
   ieast (// Outputs
          .zp     (ea_zp),
          .zn     (ea_zn),
          // Inouts
          .pad    (ea_pad),
          .aio    (ea_aio),
          .vss    (vss),
          .vdd    (ea_vdd),
          .vddio  (ea_vddio),
          .vssio  (ea_vssio),
          .ioring (ea_ioring),
          // Inputs
          .a      (ea_a),
          .ie     (ea_ie),
          .oe     (ea_oe),
          .cfg    (ea_cfg));

   // WEST
   la_ioside #(.SIDE("WE"),
               .NPINS(WE_NPINS),
               .NCELLS(WE_NCELLS),
               .NSECTIONS(WE_NSECTIONS),
               .CELLMAP(WE_CELLMAP),
               .RINGW(RINGW),
               .CFGW(CFGW))
   iwest (// Outputs
          .zp     (we_zp),
          .zn     (we_zn),
          // Inouts
          .pad    (we_pad),
          .aio    (we_aio),
          .vss    (vss),
          .vdd    (we_vdd),
          .vddio  (we_vddio),
          .vssio  (we_vssio),
          .ioring (we_ioring),
          // Inputs
          .a      (we_a),
          .ie     (we_ie),
          .oe     (we_oe),
          .cfg    (we_cfg));

   // SOUTH
   la_ioside #(.SIDE("SO"),
               .NPINS(SO_NPINS),
               .NCELLS(SO_NCELLS),
               .NSECTIONS(SO_NSECTIONS),
               .CELLMAP(SO_CELLMAP),
               .RINGW(RINGW),
               .CFGW(CFGW))
   isouth (// Outputs
           .zp     (so_zp),
           .zn     (so_zn),
           // Inouts
           .pad    (so_pad),
           .aio    (so_aio),
           .vss    (vss),
           .vdd    (so_vdd),
           .vddio  (so_vddio),
           .vssio  (so_vssio),
           .ioring (so_ioring),
           // Inputs
           .a      (so_a),
           .ie     (so_ie),
           .oe     (so_oe),
           .cfg    (so_cfg));

endmodule

//#####################################################################
// A SIMPLE TESTBENCH (FOR ELABORATION)
//#####################################################################


`ifdef TB_LA_IOPDADRING
module tb();

   localparam PERIOD = 2;
   localparam TIMEOUT = PERIOD  * 33;

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
        $display("---- AND GATE ----");
        nreset = 'b1;
        lut = 16'h8000; // 4 input and gate
        #(PERIOD * 16)
        $display("---- OR GATE ----");
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
   la_iopadring
     la_iopadring (/*AUTOINST*/
                   // Outputs
                   .no_zp               (no_zp[NO_NPINS-1:0]),
                   .no_zn               (no_zn[NO_NPINS-1:0]),
                   .ea_zp               (ea_zp[EA_NPINS-1:0]),
                   .ea_zn               (ea_zn[EA_NPINS-1:0]),
                   .so_zp               (so_zp[SO_NPINS-1:0]),
                   .so_zn               (so_zn[SO_NPINS-1:0]),
                   .we_zp               (we_zp[WE_NPINS-1:0]),
                   .we_zn               (we_zn[WE_NPINS-1:0]),
                   // Inouts
                   .vss                 (vss),
                   .no_pad              (no_pad[NO_NPINS-1:0]),
                   .no_aio              (no_aio[NO_NPINS*3-1:0]),
                   .no_vdd              (no_vdd[NO_NSECTIONS-1:0]),
                   .no_vddio            (no_vddio[NO_NSECTIONS-1:0]),
                   .no_vssio            (no_vssio[NO_NSECTIONS-1:0]),
                   .no_ioring           (no_ioring[NO_NSECTIONS*RINGW-1:0]),
                   .ea_pad              (ea_pad[EA_NPINS-1:0]),
                   .ea_aio              (ea_aio[EA_NPINS*3-1:0]),
                   .ea_vdd              (ea_vdd[EA_NSECTIONS-1:0]),
                   .ea_vddio            (ea_vddio[EA_NSECTIONS-1:0]),
                   .ea_vssio            (ea_vssio[EA_NSECTIONS-1:0]),
                   .ea_ioring           (ea_ioring[EA_NSECTIONS*RINGW-1:0]),
                   .so_pad              (so_pad[SO_NPINS-1:0]),
                   .so_aio              (so_aio[SO_NPINS*3-1:0]),
                   .so_vdd              (so_vdd[SO_NSECTIONS-1:0]),
                   .so_vddio            (so_vddio[SO_NSECTIONS-1:0]),
                   .so_vssio            (so_vssio[SO_NSECTIONS-1:0]),
                   .so_ioring           (so_ioring[SO_NSECTIONS*RINGW-1:0]),
                   .we_pad              (we_pad[WE_NPINS-1:0]),
                   .we_aio              (we_aio[WE_NPINS*3-1:0]),
                   .we_vdd              (we_vdd[WE_NSECTIONS-1:0]),
                   .we_vddio            (we_vddio[WE_NSECTIONS-1:0]),
                   .we_vssio            (we_vssio[WE_NSECTIONS-1:0]),
                   .we_ioring           (we_ioring[WE_NSECTIONS*RINGW-1:0]),
                   // Inputs
                   .no_a                (no_a[NO_NPINS-1:0]),
                   .no_ie               (no_ie[NO_NPINS-1:0]),
                   .no_oe               (no_oe[NO_NPINS-1:0]),
                   .no_cfg              (no_cfg[NO_NPINS*CFGW-1:0]),
                   .ea_a                (ea_a[EA_NPINS-1:0]),
                   .ea_ie               (ea_ie[EA_NPINS-1:0]),
                   .ea_oe               (ea_oe[EA_NPINS-1:0]),
                   .ea_cfg              (ea_cfg[EA_NPINS*CFGW-1:0]),
                   .so_a                (so_a[SO_NPINS-1:0]),
                   .so_ie               (so_ie[SO_NPINS-1:0]),
                   .so_oe               (so_oe[SO_NPINS-1:0]),
                   .so_cfg              (so_cfg[SO_NPINS*CFGW-1:0]),
                   .we_a                (we_a[WE_NPINS-1:0]),
                   .we_ie               (we_ie[WE_NPINS-1:0]),
                   .we_oe               (we_oe[WE_NPINS-1:0]),
                   .we_cfg              (we_cfg[WE_NPINS*CFGW-1:0]));

endmodule
// Local Variables:
// verilog-library-directories:("../rtl" "../../../oh/stdlib/testbench")
// End:
`endif
