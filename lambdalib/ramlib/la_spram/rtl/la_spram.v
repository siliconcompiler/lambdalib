/*****************************************************************************
 * Function: Single Port RAM
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a wrapper for selecting from a set of hardened memory macros.
 *
 * A synthesizable reference model is used when the PROP is DEFAULT. The
 * synthesizable model does not implement the cfg and test interface and should
 * only be used for basic testing and for synthesizing for FPGA devices.
 * Advanced ASIC development should rely on complete functional models
 * supplied on a per macro basis.
 *
 * Technology specific implementations of "la_spram" would generally include
 * one or more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "PROP", AW, and DW to select between the list of
 * modules at build time.
 *
 * The 'selctrl' signal tells the implementation to select the ctrl interface
 * if set to one, otherwise hard coded tech specific parameters inside the
 * lambdalib implementations are used to control the RAM.
 *
 ****************************************************************************/

module la_spram #(parameter DW = 32,          // memory width
                  parameter AW = 10,          // address width
                  parameter BYTEMASK = 0,     // 1=byte mask, 0=bit mask
                  parameter PROP = "DEFAULT", // variable for hard macro
                  parameter CTRLW = 32,       // width of ctrl interface
                  parameter STATUSW = 32      // width of status interface
                  )
   (// Memory interface
    input                          clk,     // write clock
    input                          ce,      // chip enable
    input                          we,      // write enable
    input [(BYTEMASK?DW/8:DW)-1:0] wmask,   // bit or byte write mask
    input [AW-1:0]                 addr,    //write address
    input [DW-1:0]                 din,     //write data
    output [DW-1:0]                dout,    //read output data
    // Technology interfaces
    input                          selctrl, // selects control interface
    input [CTRLW-1:0]              ctrl,    // pass through control interface
    output [STATUSW-1:0]           status   // pass through status interface
    );

   la_spram_impl #(.DW      (DW),
                   .AW      (AW),
                   .BYTEMASK(BYTEMASK),
                   .PROP    (PROP),
                   .CTRLW   (CTRLW),
                   .STATUSW (STATUSW))
   memory (// Memory interface
           .clk      (clk),
           .ce       (ce),
           .we       (we),
           .wmask    (wmask),
           .addr     (addr),
           .din      (din),
           .dout     (dout),
           // Technology interfaces
           .selctrl  (selctrl),
           .ctrl     (ctrl),
           .status   (status));

endmodule
