/*****************************************************************************
 * Function: Padring Generator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Documentation:
 *
 * - See "../README.md" for complete information
 *
 * ------------------------------------------------------------------------
 *
 * CELLMAP[79:0] = {PROP[15:0],SECTION[15:0],CELL[15:0],COMP[15:0],PIN[15:0]}
 *
 * PIN[15:0] = pin number connected to cell
 *
 * COMP[15:0] = pin number for negative leg for differential cells
 *
 * CELL[15:0] = cell type (see ./la_padring.vh)
 *
 * SECTION[15:0] = padring power section number connected to cell
 *
 * PROP[15:0] = property passed to technology specific iolib implementation
 *
 * Cell Map Example:
 *
 * CELLMAP[159:0] = {{NULL,  NULL, LA_RXDIFF, PIN_RXN, PIN_RXP}
 *                   {NULL,  NULL, LA_BIDIR,  NULL,    PIN_IO0}}
 *
 * Testing:
 *
 * >> iverilog la_iopadring.v -DTB_LA_IOPADRING -y . -y ../../iolib/rtl
 * >> ./a.out
 *
 ****************************************************************************/

module la_padring
  #(// global padring params
    parameter [15:0]       MAX = 256,        // max cells
    parameter [15:0]       CFGW = 8,         // config width
    parameter [15:0]       RINGW = 8,        // ioring width
    // per side parameters
    parameter [15:0]       NO_NPINS = 16,    // pins per side
    parameter [15:0]       NO_NCELLS = 32,   // cells per side (io, gnd, cut..)
    parameter [15:0]       NO_NSECTIONS = 1, // sections per side
    parameter [MAX*80-1:0] NO_CELLMAP = 0,   // see ../README.md
    parameter [15:0]       EA_NPINS = 16,
    parameter [15:0]       EA_NCELLS = 32,
    parameter [15:0]       EA_NSECTIONS = 1,
    parameter [MAX*80-1:0] EA_CELLMAP = 0,
    parameter [15:0]       SO_NPINS = 16,
    parameter [15:0]       SO_NCELLS = 32,
    parameter [15:0]       SO_NSECTIONS = 1,
    parameter [MAX*80-1:0] SO_CELLMAP = 0,
    parameter [15:0]       WE_NPINS = 16,
    parameter [15:0]       WE_NCELLS = 32,
    parameter [15:0]       WE_NSECTIONS = 1,
    parameter [MAX*80-1:0] WE_CELLMAP = 0
    )
   (// CONTINUOUS GROUND
    inout                          vss,
    // NORTH
    inout [NO_NPINS-1:0]           no_pad,     // pad
    inout [NO_NPINS*3-1:0]         no_aio,     // analog inout
    output [NO_NPINS-1:0]          no_zp,      // output to core (positive)
    output [NO_NPINS-1:0]          no_zn,      // output to core (negative)
    input [NO_NPINS-1:0]           no_a,       // input from core
    input [NO_NPINS-1:0]           no_ie,      // input enable, 1 = active
    input [NO_NPINS-1:0]           no_oe,      // output enable, 1 = active
    input [NO_NPINS-1:0]           no_pe,      // pull enable, 1 = enable
    input [NO_NPINS-1:0]           no_ps,      // pull select, 1 = pullup
    input [NO_NPINS-1:0]           no_schmitt, // schmitt cfg, 1 = active
    input [NO_NPINS-1:0]           no_fast,    // slew rate, 1 = fast
    input [NO_NPINS*2-1:0]         no_ds,      // drive strength, 11=strongest
    input [NO_NPINS*CFGW-1:0]      no_cfg,     // generic config interface
    inout [NO_NSECTIONS-1:0]       no_vdd,     // core supply
    inout [NO_NSECTIONS-1:0]       no_vddio,   // io/analog supply
    inout [NO_NSECTIONS-1:0]       no_vssio,   // io/analog ground
    inout [NO_NSECTIONS*RINGW-1:0] no_ioring,  // io ring
    // EAST
    inout [EA_NPINS-1:0]           ea_pad,
    inout [EA_NPINS*3-1:0]         ea_aio,
    output [EA_NPINS-1:0]          ea_zp,
    output [EA_NPINS-1:0]          ea_zn,
    input [EA_NPINS-1:0]           ea_a,
    input [EA_NPINS-1:0]           ea_ie,
    input [EA_NPINS-1:0]           ea_oe,
    input [EA_NPINS-1:0]           ea_pe,
    input [EA_NPINS-1:0]           ea_ps,
    input [EA_NPINS-1:0]           ea_schmitt,
    input [EA_NPINS-1:0]           ea_fast,
    input [EA_NPINS*2-1:0]         ea_ds,
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
    input [SO_NPINS-1:0]           so_pe,
    input [SO_NPINS-1:0]           so_ps,
    input [SO_NPINS-1:0]           so_schmitt,
    input [SO_NPINS-1:0]           so_fast,
    input [SO_NPINS*2-1:0]         so_ds,
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
    input [WE_NPINS-1:0]           we_pe,
    input [WE_NPINS-1:0]           we_ps,
    input [WE_NPINS-1:0]           we_schmitt,
    input [WE_NPINS-1:0]           we_fast,
    input [WE_NPINS*2-1:0]         we_ds,
    input [WE_NPINS*CFGW-1:0]      we_cfg,
    inout [WE_NSECTIONS-1:0]       we_vdd,
    inout [WE_NSECTIONS-1:0]       we_vddio,
    inout [WE_NSECTIONS-1:0]       we_vssio,
    inout [WE_NSECTIONS*RINGW-1:0] we_ioring
    );

`include "la_padring.vh"

   // NORTH
   la_padside #(.SIDE("NO"),
                .NPINS(NO_NPINS),
                .NCELLS(NO_NCELLS),
                .NSECTIONS(NO_NSECTIONS),
                .CELLMAP(NO_CELLMAP),
                .RINGW(RINGW),
                .CFGW(CFGW),
                .MAX(MAX))
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
           .pe     (no_pe),
           .ps     (no_ps),
           .schmitt(no_schmitt),
           .fast   (no_fast),
           .ds     (no_ds),
           .cfg    (no_cfg));

   // EAST
   la_padside #(.SIDE("EA"),
                .NPINS(EA_NPINS),
                .NCELLS(EA_NCELLS),
                .NSECTIONS(EA_NSECTIONS),
                .CELLMAP(EA_CELLMAP),
                .RINGW(RINGW),
                .CFGW(CFGW),
                .MAX(MAX))
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
          .pe     (ea_pe),
          .ps     (ea_ps),
          .schmitt(ea_schmitt),
          .fast   (ea_fast),
          .ds     (ea_ds),
          .cfg    (ea_cfg));

   // WEST
   la_padside #(.SIDE("WE"),
                .NPINS(WE_NPINS),
                .NCELLS(WE_NCELLS),
                .NSECTIONS(WE_NSECTIONS),
                .CELLMAP(WE_CELLMAP),
                .RINGW(RINGW),
                .CFGW(CFGW),
                .MAX(MAX))
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
          .pe     (we_pe),
          .ps     (we_ps),
          .schmitt(we_schmitt),
          .fast   (we_fast),
          .ds     (we_ds),
          .cfg    (we_cfg));

   // SOUTH
   la_padside #(.SIDE("SO"),
                .NPINS(SO_NPINS),
                .NCELLS(SO_NCELLS),
                .NSECTIONS(SO_NSECTIONS),
                .CELLMAP(SO_CELLMAP),
                .RINGW(RINGW),
                .CFGW(CFGW),
                .MAX(MAX))
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
           .pe     (so_pe),
           .ps     (so_ps),
           .schmitt(so_schmitt),
           .fast   (so_fast),
           .ds     (so_ds),
           .cfg    (so_cfg));

endmodule

//#####################################################################
// A SIMPLE TESTBENCH
//#####################################################################


`ifdef TB_LA_IOPADRING
module tb();

 `include "la_iopadring.vh"

   parameter PERIOD = 2;
   parameter TIMEOUT = PERIOD  * 50;

   // config
   parameter CFGW = 8;
   parameter RINGW = 8;
   parameter NPINS = 4;
   parameter NCELLS = 8;
   parameter NSECTIONS = 1;

   // pinmap
   parameter [15:0] PIN_IO0  = 8'h03;
   parameter [15:0] PIN_AN0  = 8'h02;
   parameter [15:0] PIN_RXN  = 8'h01;
   parameter [15:0] PIN_RXP  = 8'h00;


   parameter [40*NCELLS-1:0] CELLMAP =
                             {{NULL,  NULL,  LA_VSS,     NULL,    NULL},
                              {NULL,  NULL,  LA_BIDIR,   NULL,    PIN_IO0},
                              {NULL,  NULL,  LA_ANALOG,  NULL,    PIN_AN0},
                              {NULL,  NULL,  LA_VDDIO,   NULL,    NULL},
                              {NULL,  NULL,  LA_RXDIFF,  PIN_RXN, PIN_RXP},
                              {NULL,  NULL,  LA_VSS,     NULL,    NULL},
                              {NULL,  NULL,  LA_VSS,     NULL,    NULL},
                              {NULL,  NULL,  LA_VSS,     NULL,    NULL}};


   reg [NPINS-1:0]           stimulus;
   wire [NPINS-1:0]          driver;

   // control block
   initial
     begin
        $timeformat(-9, 0, " ns", 20);
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        #(TIMEOUT)
        $finish;
     end

   initial
     begin
        #(1)
        stimulus = 'b0;
        #(PERIOD * 25)
        stimulus = {NPINS{1'b1}};
     end

   assign driver = stimulus;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [EA_NPINS*3-1:0] ea_aio;
   wire [EA_NSECTIONS*RINGW-1:0] ea_ioring;
   wire [EA_NPINS-1:0]  ea_pad;
   wire [EA_NSECTIONS-1:0] ea_vdd;
   wire [EA_NSECTIONS-1:0] ea_vddio;
   wire [EA_NSECTIONS-1:0] ea_vssio;
   wire [EA_NPINS-1:0]  ea_zn;
   wire [EA_NPINS-1:0]  ea_zp;
   wire [NO_NPINS*3-1:0] no_aio;
   wire [NO_NSECTIONS*RINGW-1:0] no_ioring;
   wire [NO_NPINS-1:0]  no_pad;
   wire [NO_NSECTIONS-1:0] no_vdd;
   wire [NO_NSECTIONS-1:0] no_vddio;
   wire [NO_NSECTIONS-1:0] no_vssio;
   wire [NO_NPINS-1:0]  no_zn;
   wire [NO_NPINS-1:0]  no_zp;
   wire [SO_NPINS*3-1:0] so_aio;
   wire [SO_NSECTIONS*RINGW-1:0] so_ioring;
   wire [SO_NPINS-1:0]  so_pad;
   wire [SO_NSECTIONS-1:0] so_vdd;
   wire [SO_NSECTIONS-1:0] so_vddio;
   wire [SO_NSECTIONS-1:0] so_vssio;
   wire [SO_NPINS-1:0]  so_zn;
   wire [SO_NPINS-1:0]  so_zp;
   wire                 vss;
   wire [WE_NPINS*3-1:0] we_aio;
   wire [WE_NSECTIONS*RINGW-1:0] we_ioring;
   wire [WE_NPINS-1:0]  we_pad;
   wire [WE_NSECTIONS-1:0] we_vdd;
   wire [WE_NSECTIONS-1:0] we_vddio;
   wire [WE_NSECTIONS-1:0] we_vssio;
   wire [WE_NPINS-1:0]  we_zn;
   wire [WE_NPINS-1:0]  we_zp;
   // End of automatics

   /*la_iopadring  AUTO_TEMPLATE (
    .\(.*\)_a           ({NPINS{1'b0}}),
    .\(.*\)_ie          ({NPINS{1'b1}}),
    .\(.*\)_oe          ({NPINS{1'b0}}),
    .\(.*\)_ps          ({NPINS{1'b0}}),
    .\(.*\)_pe          ({NPINS{1'b1}}),
    .\(.*\)_cfg         ({CFGW*NPINS{1'b0}}),
    .\(.*\)_vdd         (\1_vdd[NSECTIONS-1:0]),
    .\(.*\)_vddio       (\1_vddio[NSECTIONS-1:0]),
    .\(.*\)_vssio       (\1_vssio[NSECTIONS-1:0]),
    .\(.*\)_ioring      (\1_ioring[NSECTIONS*RINGW-1:0]),
    .\(.*\)_z\(.*\)     (),
    .\(.*\)_aio\(.*\)   (),
    .\(.*\)_pad         (driver[NPINS-1:0]),
    );
    */

   // dut
   la_padring #(.CFGW(CFGW),
                  .RINGW(RINGW),
                  .NO_NPINS(NPINS),
                  .EA_NPINS(NPINS),
                  .WE_NPINS(NPINS),
                  .SO_NPINS(NPINS),
                  .NO_NCELLS(NCELLS),
                  .EA_NCELLS(NCELLS),
                  .WE_NCELLS(NCELLS),
                  .SO_NCELLS(NCELLS),
                  .NO_CELLMAP(CELLMAP),
                  .EA_CELLMAP(CELLMAP),
                  .WE_CELLMAP(CELLMAP),
                  .SO_CELLMAP(CELLMAP))
   la_padring (/*AUTOINST*/
               // Outputs
               .no_zp           (no_zp[NO_NPINS-1:0]),
               .no_zn           (no_zn[NO_NPINS-1:0]),
               .ea_zp           (ea_zp[EA_NPINS-1:0]),
               .ea_zn           (ea_zn[EA_NPINS-1:0]),
               .so_zp           (so_zp[SO_NPINS-1:0]),
               .so_zn           (so_zn[SO_NPINS-1:0]),
               .we_zp           (we_zp[WE_NPINS-1:0]),
               .we_zn           (we_zn[WE_NPINS-1:0]),
               // Inouts
               .vss             (vss),
               .no_pad          (no_pad[NO_NPINS-1:0]),
               .no_aio          (no_aio[NO_NPINS*3-1:0]),
               .no_vdd          (no_vdd[NO_NSECTIONS-1:0]),
               .no_vddio        (no_vddio[NO_NSECTIONS-1:0]),
               .no_vssio        (no_vssio[NO_NSECTIONS-1:0]),
               .no_ioring       (no_ioring[NO_NSECTIONS*RINGW-1:0]),
               .ea_pad          (ea_pad[EA_NPINS-1:0]),
               .ea_aio          (ea_aio[EA_NPINS*3-1:0]),
               .ea_vdd          (ea_vdd[EA_NSECTIONS-1:0]),
               .ea_vddio        (ea_vddio[EA_NSECTIONS-1:0]),
               .ea_vssio        (ea_vssio[EA_NSECTIONS-1:0]),
               .ea_ioring       (ea_ioring[EA_NSECTIONS*RINGW-1:0]),
               .so_pad          (so_pad[SO_NPINS-1:0]),
               .so_aio          (so_aio[SO_NPINS*3-1:0]),
               .so_vdd          (so_vdd[SO_NSECTIONS-1:0]),
               .so_vddio        (so_vddio[SO_NSECTIONS-1:0]),
               .so_vssio        (so_vssio[SO_NSECTIONS-1:0]),
               .so_ioring       (so_ioring[SO_NSECTIONS*RINGW-1:0]),
               .we_pad          (we_pad[WE_NPINS-1:0]),
               .we_aio          (we_aio[WE_NPINS*3-1:0]),
               .we_vdd          (we_vdd[WE_NSECTIONS-1:0]),
               .we_vddio        (we_vddio[WE_NSECTIONS-1:0]),
               .we_vssio        (we_vssio[WE_NSECTIONS-1:0]),
               .we_ioring       (we_ioring[WE_NSECTIONS*RINGW-1:0]),
               // Inputs
               .no_a            (no_a[NO_NPINS-1:0]),
               .no_ie           (no_ie[NO_NPINS-1:0]),
               .no_oe           (no_oe[NO_NPINS-1:0]),
               .no_pe           (no_pe[NO_NPINS-1:0]),
               .no_ps           (no_ps[NO_NPINS-1:0]),
               .no_schmitt      (no_schmitt[NO_NPINS-1:0]),
               .no_fast         (no_fast[NO_NPINS-1:0]),
               .no_ds           (no_ds[NO_NPINS*2-1:0]),
               .no_cfg          (no_cfg[NO_NPINS*CFGW-1:0]),
               .ea_a            (ea_a[EA_NPINS-1:0]),
               .ea_ie           (ea_ie[EA_NPINS-1:0]),
               .ea_oe           (ea_oe[EA_NPINS-1:0]),
               .ea_pe           (ea_pe[EA_NPINS-1:0]),
               .ea_ps           (ea_ps[EA_NPINS-1:0]),
               .ea_schmitt      (ea_schmitt[EA_NPINS-1:0]),
               .ea_fast         (ea_fast[EA_NPINS-1:0]),
               .ea_ds           (ea_ds[EA_NPINS*2-1:0]),
               .ea_cfg          (ea_cfg[EA_NPINS*CFGW-1:0]),
               .so_a            (so_a[SO_NPINS-1:0]),
               .so_ie           (so_ie[SO_NPINS-1:0]),
               .so_oe           (so_oe[SO_NPINS-1:0]),
               .so_pe           (so_pe[SO_NPINS-1:0]),
               .so_ps           (so_ps[SO_NPINS-1:0]),
               .so_schmitt      (so_schmitt[SO_NPINS-1:0]),
               .so_fast         (so_fast[SO_NPINS-1:0]),
               .so_ds           (so_ds[SO_NPINS*2-1:0]),
               .so_cfg          (so_cfg[SO_NPINS*CFGW-1:0]),
               .we_a            (we_a[WE_NPINS-1:0]),
               .we_ie           (we_ie[WE_NPINS-1:0]),
               .we_oe           (we_oe[WE_NPINS-1:0]),
               .we_pe           (we_pe[WE_NPINS-1:0]),
               .we_ps           (we_ps[WE_NPINS-1:0]),
               .we_schmitt      (we_schmitt[WE_NPINS-1:0]),
               .we_fast         (we_fast[WE_NPINS-1:0]),
               .we_ds           (we_ds[WE_NPINS*2-1:0]),
               .we_cfg          (we_cfg[WE_NPINS*CFGW-1:0]));

endmodule
// Local Variables:
// verilog-library-directories:("../rtl" "../../../oh/stdlib/testbench")
// End:
`endif
