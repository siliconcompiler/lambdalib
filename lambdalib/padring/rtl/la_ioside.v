/*****************************************************************************
 * Function: Padring Side Module
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Documentation:
 *
 * See "../README.md" for complete information
 *
 * -------------------------------------------------------------------------
 *
 *
 * CELLMAP[39:0] = {PROP[7:0],SECTION[7:0],CELL[7:0],COMP[7:0],PIN[7:0]}
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
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter [15:0]          SIDE = "NO",   // "NO", "SO", "EA", "WE"
    parameter [7:0]           NPINS = 1,     // total pins per side (<256)
    parameter [7:0]           NCELLS = 1,    // total cells per side (<256)
    parameter [7:0]           NSECTIONS = 1, // total power sections (<256)
    parameter [NCELLS*40-1:0] CELLMAP = 0,   // see ../README.md
    parameter                 RINGW = 1,     // width of io ring
    parameter                 CFGW = 1       // config width
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
    input [NPINS*CFGW-1:0]      cfg,   // generic config interface
    // supplies/ring (per cell)
    inout                       vss,   // common ground
    inout [NSECTIONS-1:0]       vdd,   // core supply
    inout [NSECTIONS-1:0]       vddio, // io supply
    inout [NSECTIONS-1:0]       vssio, // io ground
    inout [NSECTIONS*RINGW-1:0] ioring // generic io-ring
    );

`include "la_iopadring.vh"

   genvar i;

   for (i = 0; i < NCELLS; i = i + 1)
     begin : ipad
        // LA_BIDIR
        if (CELLMAP[(i*40+16)+:8] == LA_BIDIR)
          begin : gbidir
             la_iobidir #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:8]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:8]]),
                 // core signalas
                 .z(zp[CELLMAP[(i*40)+:8]]),
                 .a(a[CELLMAP[(i*40)+:8]]),
                 .ie(ie[CELLMAP[(i*40)+:8]]),
                 .oe(oe[CELLMAP[(i*40)+:8]]),
                 .cfg(cfg[CELLMAP[(i*40)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_INPUT
        if (CELLMAP[(i*40+16)+:8] == LA_INPUT)
          begin : ginput
             la_ioinput #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:8]),
                          .CFGW(CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:8]]),
                 // core signalas
                 .z(zp[CELLMAP[(i*40)+:8]]),
                 .ie(ie[CELLMAP[(i*40)+:8]]),
                 .cfg(cfg[CELLMAP[(i*40)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_ANALOG
        if (CELLMAP[(i*40+16)+:8] == LA_ANALOG)
          begin : ganalog
             la_ioanalog #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:8]),
                           .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*40)+:8]]),
                 // core signalas
                 .aio(aio[CELLMAP[(i*40)+:8]*3+:3]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_XTAL
        if (CELLMAP[(i*40+16)+:8] == LA_XTAL)
          begin : gxtal
             la_ioxtal #(.SIDE(SIDE),
                         .PROP(CELLMAP[(i*40+32)+:8]),
                         .CFGW(CFGW),
                         .RINGW(RINGW))
             i0 (// pad
                 .padi(pad[CELLMAP[(i*40)+:8]]),
                 .pado(pad[CELLMAP[(i*40+8)+:8]]),
                 // core
                 .z(zp[CELLMAP[(i*40)+:8]]),
                 .cfg(cfg[CELLMAP[(i*40)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_RXDIFF
        if (CELLMAP[(i*40+16)+:8] == LA_RXDIFF)
          begin : grxdiff
             la_iorxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:8]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*40)+:8]]),
                 .padn(pad[CELLMAP[(i*40+8)+:8]]),
                 // core
                 .zp(zp[CELLMAP[(i*40)+:8]]),
                 .zn(zn[CELLMAP[(i*40)+:8]]),
                 .ie(ie[CELLMAP[(i*40)+:8]]),
                 .cfg(cfg[CELLMAP[(i*40)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_TXDIFF
        if (CELLMAP[(i*40+16)+:8] == LA_TXDIFF)
          begin : gtxdiff
             la_iotxdiff #(.SIDE(SIDE),
                           .PROP(CELLMAP[(i*40+32)+:8]),
                           .CFGW(CFGW),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*40)+:8]]),
                 .padn(pad[CELLMAP[(i*40+8)+:8]]),
                 // core
                 .a(a[CELLMAP[(i*40)+:8]]),
                 .oe(oe[CELLMAP[(i*40)+:8]]),
                 .cfg(cfg[CELLMAP[(i*40)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_POC
        if (CELLMAP[(i*40+16)+:8] == LA_POC)
          begin : gpoc
             la_iopoc #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:8]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_CUT
        if (CELLMAP[(i*40+16)+:8] == LA_CUT)
          begin : icut
             la_iocut #(.SIDE (SIDE),
                        .PROP (CELLMAP[(i*40+32)+:8]),
                        .RINGW(RINGW))
             i0 (.vss(vss));
          end
        if (CELLMAP[(i*40+16)+:8] == LA_VDDIO)
          begin : gvddio
             la_iovddio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:8]),
                          .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_VSSIO
        if (CELLMAP[(i*40+16)+:8] == LA_VSSIO)
          begin : gvssio
             la_iovssio #(.SIDE(SIDE),
                          .PROP(CELLMAP[(i*40+32)+:8]),
                          .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_VDD
        if (CELLMAP[(i*40+16)+:8] == LA_VDD)
          begin : gvdd
             la_iovdd #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:8]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_VSS
        if (CELLMAP[(i*40+16)+:8] == LA_VSS)
          begin : gvss
            la_iovss #(.SIDE(SIDE),
                       .PROP(CELLMAP[(i*40+32)+:8]),
                       .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_VDDA
        if (CELLMAP[(i*40+16)+:8] == LA_VDDA)
          begin : gvdda
            la_iovdda #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:8]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
        // LA_VSSA
        if (CELLMAP[(i*40+16)+:8] == LA_VSSA)
          begin : gvssa
            la_iovssa #(.SIDE(SIDE),
                        .PROP(CELLMAP[(i*40+32)+:8]),
                        .RINGW(RINGW))
             i0 (.vss(vss),
                 .vdd(vdd[CELLMAP[(i*40+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*40+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*40+24)+:8]]),
                 .ioring(ioring[CELLMAP[(i*40+24)+:8]*RINGW+:RINGW]));
          end
     end

endmodule
