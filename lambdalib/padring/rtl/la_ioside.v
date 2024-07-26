/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter SIDE = "NO",   // "NO", "SO", "EA", "WE"
    parameter NPINS = 1,     // total pins per side (<256)
    parameter NCELLS = 1,    // total cells per side (<256)
    parameter NSECTIONS = 1, // total secti0ns per side (<256)
    parameter CELLMAP = 0,   // {SECTION#, TYPE, CELL, PIN#}
    parameter RINGW = 1,     // width of io ring
    parameter CFGW = 1       // config width
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
        if (CELLMAP[(i*24+8)+:8] == LA_BIDIR)
          begin : g0
             la_iobidir #(.SIDE (SIDE),
                          .TYPE (CELLMAP[(i*24+16)+:8]),
                          .CFGW (CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*24)+:8]]),
                 // core signalas
                 .z(zp[CELLMAP[(i*24)+:8]]),
                 .a(a[CELLMAP[(i*24)+:8]]),
                 .ie(ie[CELLMAP[(i*24)+:8]]),
                 .oe(oe[CELLMAP[(i*24)+:8]]),
                 .cfg(cfg[CELLMAP[(i*24)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_INPUT)
          begin : g0
             la_ioinput #(.SIDE (SIDE),
                          .TYPE (CELLMAP[(i*24+16)+:4]),
                          .CFGW (CFGW),
                          .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*24)+:8]]),
                 // core signalas
                 .z(zp[CELLMAP[(i*24)+:8]]),
                 .ie(ie[CELLMAP[(i*24)+:8]]),
                 .cfg(cfg[CELLMAP[(i*24)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_ANALOG)
          begin : g0
             la_ioanalog #(.SIDE (SIDE),
                           .TYPE (CELLMAP[(i*24+16)+:4]),
                           .RINGW(RINGW))
             i0 (// pad
                 .pad(pad[CELLMAP[(i*24)+:8]]),
                 // core signalas
                 .aio(aio[CELLMAP[(i*24)+:8]*3+:3]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_XTAL)
          begin : g0
             la_ioxtal #(.SIDE (SIDE),
                         .TYPE (CELLMAP[(i*24+16)+:4]),
                         .RINGW(RINGW))
             i0 (// pad
                 .padi(pad[CELLMAP[(i*24)+:8]]),
                 .pado(pad[i+1]),  //TODO: fix!
                 // core
                 .z(zp[CELLMAP[(i*24)+:8]]),
                 .cfg(cfg[CELLMAP[(i*24)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_RXDIFF)
          begin : g0
             la_iorxdiff #(.SIDE (SIDE),
                           .TYPE (CELLMAP[(i*24+16)+:8]),
                           .RINGW(RINGW))
             i0 (// pad
                 .padp(pad[CELLMAP[(i*24)+:8]]),
                 .padn(pad[i+1]),  //TODO: fix!
                 // core
                 .zp(zp[CELLMAP[(i*24)+:8]]),
                 .zn(zn[CELLMAP[(i*24)+:8]]),
                 .ie(ie[CELLMAP[(i*24)+:8]]),
                 .cfg(cfg[CELLMAP[(i*24)+:8]*CFGW+:CFGW]),
                 // supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_TXDIFF) begin : g0
            la_iotxdiff #(
                .SIDE (SIDE),
                .TYPE (CELLMAP[(i*24+16)+:4]),
                .RINGW(RINGW)
            ) i0 (  // pad
                .padp(pad[CELLMAP[(i*24)+:8]]),
                .padn(pad[i+1]),  //TODO: assume compliment is next pin?
                // core
                .a(a[CELLMAP[(i*24)+:8]]),
                .oe(oe[CELLMAP[(i*24)+:8]]),
                .cfg(cfg[CELLMAP[(i*24)+:8]*CFGW+:CFGW]),
                // supplies
                .vss(vss),
                .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                // ring
                .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW])
            );
        end
        else if (CELLMAP[(i*24)+:8] == LA_POC)
          begin : g0
             la_iopoc #(.SIDE (SIDE),
                        .TYPE (CELLMAP[(i*24+16)+:4]),
                        .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_CUT)
          begin : ila_iocut
             la_iocut #(.SIDE (SIDE),
                        .TYPE (CELLMAP[(i*24+16)+:4]),
                        .RINGW(RINGW))
             i0 (.vss(vss));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VDDIO)
          begin : g0
             la_iovddio #(.SIDE (SIDE),
                          .TYPE (CELLMAP[((i*24)+4)+:4]),
                          .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VSSIO)
          begin : g0
             la_iovssio #(.SIDE (SIDE),
                          .TYPE (CELLMAP[(i*24+16)+:4]),
                          .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VDD)
          begin : g0
             la_iovdd #(.SIDE (SIDE),
                        .TYPE (CELLMAP[(i*24+16)+:4]),
                        .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VSS)
          begin : g0
            la_iovss #(.SIDE (SIDE),
                       .TYPE (CELLMAP[(i*24+16)+:4]),
                       .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VDDA)
          begin : g0
            la_iovdda #(.SIDE (SIDE),
                        .TYPE (CELLMAP[(i*24+16)+:4]),
                        .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
        else if (CELLMAP[(i*24)+:8] == LA_VSSA)
          begin : g0
            la_iovssa #(.SIDE (SIDE),
                        .TYPE (CELLMAP[(i*24+16)+:4]),
                        .RINGW(RINGW))
             i0 (// supplies
                 .vss(vss),
                 .vdd(vdd[CELLMAP[(i*24+24)+:8]]),
                 .vddio(vddio[CELLMAP[(i*24+24)+:8]]),
                 .vssio(vssio[CELLMAP[(i*24+24)+:8]]),
                 // ring
                 .ioring(ioring[CELLMAP[(i*24+24)+:8]*RINGW+:RINGW]));
          end
     end

endmodule
