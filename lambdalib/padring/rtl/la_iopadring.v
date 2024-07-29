/*****************************************************************************
 * Function: Padring Generator
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Documentation:
 *
 * - See "../README.md" for complete information
 *
 * PIN[7:0] = pin number connected to cell
 *
 * COMP[7:0] = pin number for negative pad for differential cells
 *
 * CELL[7:0] = cell type (see ./la_padring.vh)
 *
 * SECTION[7:0] = padring power section number connected to cell
 *
 * PROP[7:0] = property passed to technology specific iolib implementation
 *
 * Cell Map Example:
 *
 * CELLMAP[79:0] = {{NULL,  NULL, LA_RXDIFF, PIN_RXN, PIN_RXP}
 *                  {NULL,  NULL, LA_BIDIR,  NULL,    PIN_IO0}}
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
    parameter                    CFGW = 8,         // config width
    parameter                    RINGW = 8,        // ioring width
    parameter                    NO_NPINS = 1,     // pins per side
    parameter                    NO_NCELLS = 1,    // cells per side
    parameter                    NO_NSECTIONS = 1, // sections per side
    parameter [NO_NCELLS*40-1:0] NO_CELLMAP = 0,   // see ../README.md
    parameter                    EA_NPINS = 1,
    parameter                    EA_NCELLS = 1,
    parameter                    EA_NSECTIONS = 1,
    parameter [EA_NCELLS*40-1:0] EA_CELLMAP = 0,
    parameter                    SO_NPINS = 1,
    parameter                    SO_NCELLS = 1,
    parameter                    SO_NSECTIONS = 1,
    parameter [SO_NCELLS*40-1:0] SO_CELLMAP = 0,
    parameter                    WE_NPINS = 1,
    parameter                    WE_NCELLS = 1,
    parameter                    WE_NSECTIONS = 1,
    parameter [WE_NCELLS*40-1:0] WE_CELLMAP = 0
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
   parameter [7:0] PIN_IO0  = 8'h03;
   parameter [7:0] PIN_AN0  = 8'h02;
   parameter [7:0] PIN_RXN  = 8'h01;
   parameter [7:0] PIN_RXP  = 8'h00;


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
   wire [NSECTIONS*RINGW-1:0] ea_ioring;
   wire [NSECTIONS-1:0] ea_vdd;
   wire [NSECTIONS-1:0] ea_vddio;
   wire [NSECTIONS-1:0] ea_vssio;
   wire [NSECTIONS*RINGW-1:0] no_ioring;
   wire [NSECTIONS-1:0] no_vdd;
   wire [NSECTIONS-1:0] no_vddio;
   wire [NSECTIONS-1:0] no_vssio;
   wire [NSECTIONS*RINGW-1:0] so_ioring;
   wire [NSECTIONS-1:0] so_vdd;
   wire [NSECTIONS-1:0] so_vddio;
   wire [NSECTIONS-1:0] so_vssio;
   wire                 vss;
   wire [NSECTIONS*RINGW-1:0] we_ioring;
   wire [NSECTIONS-1:0] we_vdd;
   wire [NSECTIONS-1:0] we_vddio;
   wire [NSECTIONS-1:0] we_vssio;
   // End of automatics

   /*la_iopadring  AUTO_TEMPLATE (
    .\(.*\)_a           ({NPINS{1'b0}}),
    .\(.*\)_ie          ({NPINS{1'b1}}),
    .\(.*\)_oe          ({NPINS{1'b0}}),
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
   la_iopadring #(.CFGW(CFGW),
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
   la_iopadring (/*AUTOINST*/
                 // Outputs
                 .no_zp                 (),                      // Templated
                 .no_zn                 (),                      // Templated
                 .ea_zp                 (),                      // Templated
                 .ea_zn                 (),                      // Templated
                 .so_zp                 (),                      // Templated
                 .so_zn                 (),                      // Templated
                 .we_zp                 (),                      // Templated
                 .we_zn                 (),                      // Templated
                 // Inouts
                 .vss                   (vss),
                 .no_pad                (driver[NPINS-1:0]),     // Templated
                 .no_aio                (),                      // Templated
                 .no_vdd                (no_vdd[NSECTIONS-1:0]), // Templated
                 .no_vddio              (no_vddio[NSECTIONS-1:0]), // Templated
                 .no_vssio              (no_vssio[NSECTIONS-1:0]), // Templated
                 .no_ioring             (no_ioring[NSECTIONS*RINGW-1:0]), // Templated
                 .ea_pad                (driver[NPINS-1:0]),     // Templated
                 .ea_aio                (),                      // Templated
                 .ea_vdd                (ea_vdd[NSECTIONS-1:0]), // Templated
                 .ea_vddio              (ea_vddio[NSECTIONS-1:0]), // Templated
                 .ea_vssio              (ea_vssio[NSECTIONS-1:0]), // Templated
                 .ea_ioring             (ea_ioring[NSECTIONS*RINGW-1:0]), // Templated
                 .so_pad                (driver[NPINS-1:0]),     // Templated
                 .so_aio                (),                      // Templated
                 .so_vdd                (so_vdd[NSECTIONS-1:0]), // Templated
                 .so_vddio              (so_vddio[NSECTIONS-1:0]), // Templated
                 .so_vssio              (so_vssio[NSECTIONS-1:0]), // Templated
                 .so_ioring             (so_ioring[NSECTIONS*RINGW-1:0]), // Templated
                 .we_pad                (driver[NPINS-1:0]),     // Templated
                 .we_aio                (),                      // Templated
                 .we_vdd                (we_vdd[NSECTIONS-1:0]), // Templated
                 .we_vddio              (we_vddio[NSECTIONS-1:0]), // Templated
                 .we_vssio              (we_vssio[NSECTIONS-1:0]), // Templated
                 .we_ioring             (we_ioring[NSECTIONS*RINGW-1:0]), // Templated
                 // Inputs
                 .no_a                  ({NPINS{1'b0}}),         // Templated
                 .no_ie                 ({NPINS{1'b1}}),         // Templated
                 .no_oe                 ({NPINS{1'b0}}),         // Templated
                 .no_cfg                ({CFGW*NPINS{1'b0}}),    // Templated
                 .ea_a                  ({NPINS{1'b0}}),         // Templated
                 .ea_ie                 ({NPINS{1'b1}}),         // Templated
                 .ea_oe                 ({NPINS{1'b0}}),         // Templated
                 .ea_cfg                ({CFGW*NPINS{1'b0}}),    // Templated
                 .so_a                  ({NPINS{1'b0}}),         // Templated
                 .so_ie                 ({NPINS{1'b1}}),         // Templated
                 .so_oe                 ({NPINS{1'b0}}),         // Templated
                 .so_cfg                ({CFGW*NPINS{1'b0}}),    // Templated
                 .we_a                  ({NPINS{1'b0}}),         // Templated
                 .we_ie                 ({NPINS{1'b1}}),         // Templated
                 .we_oe                 ({NPINS{1'b0}}),         // Templated
                 .we_cfg                ({CFGW*NPINS{1'b0}}));   // Templated

endmodule
// Local Variables:
// verilog-library-directories:("../rtl" "../../../oh/stdlib/testbench")
// End:
`endif
