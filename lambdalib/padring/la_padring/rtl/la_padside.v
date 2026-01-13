/**************************************************************************
 * Function: Padring Side Module
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Documentation:
 *
 * See "../README.md" for complete information
 *
 **************************************************************/

module la_padside
  #(// per side parameters
    parameter [15:0]       SIDE = "NO",   // "NO", "SO", "EA", "WE"
    parameter [15:0]       MAX = 256,     // max cells
    parameter [15:0]       NPINS = 1,     // total pins per side (<256)
    parameter [15:0]       NCELLS = 1,    // total cells per side (<256)
    parameter [15:0]       NSECTIONS = 1, // total power sections (<256)
    parameter [MAX*80-1:0] CELLMAP = 0,   // see ../README.md
    parameter [15:0]       RINGW = 1,     // width of io ring
    parameter [15:0]       CFGW = 1       // config width
    )
   (// io pad signals
    inout [NPINS-1:0]           pad,   // pad
    //core facing signals
    inout [NPINS*3-1:0]         aio,   // analog inout
    output [NPINS-1:0]          zp,    // positive output to core
    output [NPINS-1:0]          zn,    // negative output to core
    input [NPINS-1:0]           a,     // input from core
    input [NPINS-1:0]           ie,    // input enable, 1 = active
    input [NPINS-1:0]           oe,    // output enable, 1 = active
    input [NPINS-1:0]           pe,    // pull enable, 1 = enable
    input [NPINS-1:0]           ps,    // pull select, 1 = pullup
    input [NPINS*CFGW-1:0]      cfg,   // generic config interface
    // supplies/ring (per cell)
    inout                       vss,   // common ground
    inout [NSECTIONS-1:0]       vdd,   // core supply
    inout [NSECTIONS-1:0]       vddio, // io supply
    inout [NSECTIONS-1:0]       vssio, // io ground
    inout [NSECTIONS*RINGW-1:0] ioring // generic io-ring
    );

   // Field width

   localparam FW            = 16;     // field width
   localparam CMW           = 5 * FW; // cell map
   localparam INDEX_COMP    = 1 * FW; // complimentary pin index
   localparam INDEX_CELL    = 2 * FW; // cell index
   localparam INDEX_SECTION = 3 * FW; // section index
   localparam INDEX_PROP    = 4 * FW; // property index


   //#######################################################################
   /* verilator lint_off WIDTHTRUNC */
   //#######################################################################
   // Safe to disable check b/c MAX cells should be consistent with the
   // CELLMAP, which should be generated.
   //#######################################################################


`include "la_padring.vh"

   genvar i;

   for (i = 0; i < NCELLS; i = i + 1)
     begin : ipad
        // LA_BIDIR
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_BIDIR)
          begin : gbidir
             la_iobidir #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*CMW)+:FW]]),
                 // core signals
                 .z(zp[CELLMAP[(i*CMW)+:FW]]),
                 .a(a[CELLMAP[(i*CMW)+:FW]]),
                 .ie(ie[CELLMAP[(i*CMW)+:FW]]),
                 .oe(oe[CELLMAP[(i*CMW)+:FW]]),
                 .pe(pe[CELLMAP[(i*CMW)+:FW]]),
                 .ps(ps[CELLMAP[(i*CMW)+:FW]]),
                 .cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_INPUT
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_INPUT)
          begin : ginput
             la_ioinput #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*CMW)+:FW]]),
                 // core signals
                 .z(zp[CELLMAP[(i*CMW)+:FW]]),
                 .ie(ie[CELLMAP[(i*CMW)+:FW]]),
                 .pe(pe[CELLMAP[(i*CMW)+:FW]]),
                 .ps(ps[CELLMAP[(i*CMW)+:FW]]),
                 .cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_ANALOG
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_ANALOG)
          begin : ganalog
             la_ioanalog #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*CMW)+:FW]]),
                 // core signals
                 .aio(aio[CELLMAP[(i*CMW)+:FW]*3+:3]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_XTAL
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_XTAL)
          begin : gxtal
             la_ioxtal #(.SIDE(SIDE),
                         .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                         .CFGW(CFGW),
                         .RINGW(RINGW))
             i0 (// pad
                 .padi(pad[CELLMAP[(i*CMW)+:FW]]),
                 .pado(pad[CELLMAP[(i*CMW+INDEX_COMP)+:FW]]),
                 // core
                 .z(zp[CELLMAP[(i*CMW)+:FW]]),
                 .cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_RXDIFF
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_RXDIFF)
          begin : grxdiff
             la_iorxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*CMW)+:FW]]),
                 .padn(pad[CELLMAP[(i*CMW+INDEX_COMP)+:FW]]),
                 // core
                 .zp(zp[CELLMAP[(i*CMW)+:FW]]),
                 .zn(zn[CELLMAP[(i*CMW)+:FW]]),
                 .ie(ie[CELLMAP[(i*CMW)+:FW]]),
                 .cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_TXDIFF
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_TXDIFF)
          begin : gtxdiff
             la_iotxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*CMW)+:FW]]),
                 .padn(pad[CELLMAP[(i*CMW+INDEX_COMP)+:FW]]),
                 // core
                 .a(a[CELLMAP[(i*CMW)+:FW]]),
                 .oe(oe[CELLMAP[(i*CMW)+:FW]]),
                 .cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_POC
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_POC)
          begin : gpoc
             la_iopoc #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                        .CFGW(CFGW),
                        .RINGW(RINGW))
             i0 (.cfg(cfg[CELLMAP[(i*CMW)+:FW]*CFGW+:CFGW]),
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_CUT
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_CUT)
          begin : icut
             if (i - 1 < 0 && i + 1 == NCELLS)
              begin: icut_invalid
              end
             if (i - 1 < 0 && i + 1 <= NCELLS - 1)
              begin: icut_start
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(),
                    .vdd1(vdd[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .vddio0(),
                    .vddio1(vddio[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .vssio0(),
                    .vssio1(vssio[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .ioring0(),
                    .ioring1(ioring[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
              end
             if (i - 1 >= 0 && i + 1 <= NCELLS - 1)
              begin: icut_middle
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(vdd[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vdd1(vdd[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .vddio0(vddio[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vddio1(vddio[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .vssio0(vssio[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vssio1(vssio[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]]),
                    .ioring0(ioring[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]),
                    .ioring1(ioring[CELLMAP[((i+1)*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
              end
             if (i - 1 >= 0 && i + 1 == NCELLS)
              begin: icut_end
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(vdd[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vdd1(),
                    .vddio0(vddio[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vddio1(),
                    .vssio0(vssio[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]]),
                    .vssio1(),
                    .ioring0(ioring[CELLMAP[((i-1)*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]),
                    .ioring1());
              end
          end
        // LA_VDDIO
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VDDIO)
          begin : gvddio
             la_iovddio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                          .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_VSSIO
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VSSIO)
          begin : gvssio
             la_iovssio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                          .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_VDD
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VDD)
          begin : gvdd
             la_iovdd #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_VSS
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VSS)
          begin : gvss
            la_iovss #(.SIDE(SIDE),
                       .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                       .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_VDDA
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VDDA)
          begin : gvdda
            la_iovdda #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_VSSA
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_VSSA)
          begin : gvssa
            la_iovssa #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
        // LA_CLAMP
        if (CELLMAP[(i*CMW+INDEX_CELL)+:FW] == LA_CLAMP)
          begin : gclamp
            la_ioclamp #(.SIDE(SIDE),
                         .PROP(CELLMAP[(i*CMW+INDEX_PROP)+:FW]),
                         .RINGW(RINGW))
             i0 (.pad(pad[CELLMAP[(i*CMW)+:FW]]),
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vddio(vddio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .vssio(vssio[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]]),
                 .ioring(ioring[CELLMAP[(i*CMW+INDEX_SECTION)+:FW]*RINGW+:RINGW]));
          end
     end

endmodule
