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
    parameter [15:0]         SIDE = "NO",   // "NO", "SO", "EA", "WE"
    parameter [15:0]         NPINS = 1,     // total pins per side (<256)
    parameter [15:0]         NCELLS = 1,    // total cells per side (<256)
    parameter [15:0]         NSECTIONS = 1, // total power sections (<256)
    parameter [65536*80-1:0] CELLMAP = 0,   // see ../README.md
    parameter [15:0]         RINGW = 1,     // width of io ring
    parameter [15:0]         CFGW = 1       // config width
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

   //#######################################################################
   /* verilator lint_off WIDTHTRUNC */
   //#######################################################################
   // Safe to disable check b/c the index is 8 bits and the number of pads
   // per side is always <= 256.
   //#######################################################################


`include "la_padring.vh"

   genvar i;

   for (i = 0; i < NCELLS; i = i + 1)
     begin : ipad
        // LA_BIDIR
        if (CELLMAP[(i*40+16)+:16] == LA_BIDIR)
          begin : gbidir
             la_iobidir #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:16]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:16]]),
                 // core signals
                 .z(zp[CELLMAP[(i*40)+:16]]),
                 .a(a[CELLMAP[(i*40)+:16]]),
                 .ie(ie[CELLMAP[(i*40)+:16]]),
                 .oe(oe[CELLMAP[(i*40)+:16]]),
                 .pe(pe[CELLMAP[(i*40)+:16]]),
                 .ps(ps[CELLMAP[(i*40)+:16]]),
                 .cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_INPUT
        if (CELLMAP[(i*40+16)+:16] == LA_INPUT)
          begin : ginput
             la_ioinput #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:16]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:16]]),
                 // core signals
                 .z(zp[CELLMAP[(i*40)+:16]]),
                 .ie(ie[CELLMAP[(i*40)+:16]]),
                 .pe(pe[CELLMAP[(i*40)+:16]]),
                 .ps(ps[CELLMAP[(i*40)+:16]]),
                 .cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_ANALOG
        if (CELLMAP[(i*40+16)+:16] == LA_ANALOG)
          begin : ganalog
             la_ioanalog #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:16]]),
                 // core signals
                 .aio(aio[{1'b0, CELLMAP[(i*40)+:16]}+:3]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_XTAL
        if (CELLMAP[(i*40+16)+:16] == LA_XTAL)
          begin : gxtal
             la_ioxtal #(.SIDE(SIDE),
                         .PROP(CELLMAP[(i*40+32)+:16]),
                         .CFGW(CFGW),
                         .RINGW(RINGW))
             i0 (// pad
                 .padi(pad[CELLMAP[(i*40)+:16]]),
                 .pado(pad[CELLMAP[(i*40+8)+:16]]),
                 // core
                 .z(zp[CELLMAP[(i*40)+:16]]),
                 .cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_RXDIFF
        if (CELLMAP[(i*40+16)+:16] == LA_RXDIFF)
          begin : grxdiff
             la_iorxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*40)+:16]]),
                 .padn(pad[CELLMAP[(i*40+8)+:16]]),
                 // core
                 .zp(zp[CELLMAP[(i*40)+:16]]),
                 .zn(zn[CELLMAP[(i*40)+:16]]),
                 .ie(ie[CELLMAP[(i*40)+:16]]),
                 .cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_TXDIFF
        if (CELLMAP[(i*40+16)+:16] == LA_TXDIFF)
          begin : gtxdiff
             la_iotxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*40)+:16]]),
                 .padn(pad[CELLMAP[(i*40+8)+:16]]),
                 // core
                 .a(a[CELLMAP[(i*40)+:16]]),
                 .oe(oe[CELLMAP[(i*40)+:16]]),
                 .cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_POC
        if (CELLMAP[(i*40+16)+:16] == LA_POC)
          begin : gpoc
             la_iopoc #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:16]),
                        .CFGW(CFGW),
                        .RINGW(RINGW))
             i0 (.cfg(cfg[{2'b00, CELLMAP[(i*40)+:16]}*CFGW +: CFGW]),
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_CUT
        if (CELLMAP[(i*40+16)+:16] == LA_CUT)
          begin : icut
             if (i - 1 < 0 && i + 1 == NCELLS)
              begin: icut_invalid
              end
             if (i - 1 < 0 && i + 1 <= NCELLS - 1)
              begin: icut_start
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(),
                    .vdd1(vdd[CELLMAP[((i+1)*40+24)+:16]]),
                    .vddio0(),
                    .vddio1(vddio[CELLMAP[((i+1)*40+24)+:16]]),
                    .vssio0(),
                    .vssio1(vssio[CELLMAP[((i+1)*40+24)+:16]]),
                    .ioring0(),
                    .ioring1(ioring[CELLMAP[((i+1)*40+24)+:16]*RINGW+:RINGW]));
              end
             if (i - 1 >= 0 && i + 1 <= NCELLS - 1)
              begin: icut_middle
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(vdd[CELLMAP[((i-1)*40+24)+:16]]),
                    .vdd1(vdd[CELLMAP[((i+1)*40+24)+:16]]),
                    .vddio0(vddio[CELLMAP[((i-1)*40+24)+:16]]),
                    .vddio1(vddio[CELLMAP[((i+1)*40+24)+:16]]),
                    .vssio0(vssio[CELLMAP[((i-1)*40+24)+:16]]),
                    .vssio1(vssio[CELLMAP[((i+1)*40+24)+:16]]),
                    .ioring0(ioring[CELLMAP[((i-1)*40+24)+:16]*RINGW+:RINGW]),
                    .ioring1(ioring[CELLMAP[((i+1)*40+24)+:16]*RINGW+:RINGW]));
              end
             if (i - 1 >= 0 && i + 1 == NCELLS)
              begin: icut_end
                la_iocut #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:16]),
                           .RINGW(RINGW))
                i0 (.vss(vss),
                    .vdd0(vdd[CELLMAP[((i-1)*40+24)+:16]]),
                    .vdd1(),
                    .vddio0(vddio[CELLMAP[((i-1)*40+24)+:16]]),
                    .vddio1(),
                    .vssio0(vssio[CELLMAP[((i-1)*40+24)+:16]]),
                    .vssio1(),
                    .ioring0(ioring[CELLMAP[((i-1)*40+24)+:16]*RINGW+:RINGW]),
                    .ioring1());
              end
          end
        // LA_VDDIO
        if (CELLMAP[(i*40+16)+:16] == LA_VDDIO)
          begin : gvddio
             la_iovddio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:16]),
                          .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_VSSIO
        if (CELLMAP[(i*40+16)+:16] == LA_VSSIO)
          begin : gvssio
             la_iovssio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:16]),
                          .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_VDD
        if (CELLMAP[(i*40+16)+:16] == LA_VDD)
          begin : gvdd
             la_iovdd #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:16]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_VSS
        if (CELLMAP[(i*40+16)+:16] == LA_VSS)
          begin : gvss
            la_iovss #(.SIDE(SIDE),
                       .PROP(CELLMAP[(i*40+32)+:16]),
                       .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_VDDA
        if (CELLMAP[(i*40+16)+:16] == LA_VDDA)
          begin : gvdda
            la_iovdda #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:16]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_VSSA
        if (CELLMAP[(i*40+16)+:16] == LA_VSSA)
          begin : gvssa
            la_iovssa #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:16]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
        // LA_CLAMP
        if (CELLMAP[(i*40+16)+:16] == LA_CLAMP)
          begin : gclamp
            la_ioclamp #(.SIDE(SIDE),
                         .PROP(CELLMAP[(i*40+32)+:16]),
                         .RINGW(RINGW))
             i0 (.pad(pad[CELLMAP[(i*40)+:16]]),
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:16]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:16]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:16]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:16]*RINGW+:RINGW]));
          end
     end

endmodule
