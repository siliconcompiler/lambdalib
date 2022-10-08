/*****************************************************************************
 * Function: RAM (Single port)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a wrapper for selecting from a set of hardened memory macros.
 *
 * A synthesizable reference model is used when the TYPE is DEFAULT. The
 * synthesizable model does not implement the cfg and test interface and should
 * only be used for basic testing and for synthesizing for FPGA devices.
 * Advanced ASIC development should rely on complete functional models
 * supplied on a per macro basis.
 *
 * Technologoy specific implementations of "la_ram" would generally include
 * one ore more hardcoded instantiations of RAM modules with a generate
 * statement relying on the "TYPE" to select between the list of modules
 * at build time.
 *
 ****************************************************************************/

module la_spram
  #(parameter DW     = 32,            // Memory width
    parameter DEPTH  = 32,            // Memory depth
    parameter AW     = $clog2(DEPTH), // address width (derived)
    parameter TYPE   = "DEFAULT",     // pass through variable for hard macro
    parameter REG    = 1,             // adds pipeline stage to soft RAM
    parameter CTRLW  = 128,           // width of asic ctrl interface
    parameter TESTW  = 128            // width of asic teset interface
    )
   (// Memory interface (dual port)
    input 	      clk, // write clock
    input 	      ce, // chip enable
    input 	      we, // write enable
    input [DW-1:0]    wmask, //per bit write mask
    input [AW-1:0]    addr,//write address
    input [DW-1:0]    din, //write data
    output [DW-1:0]   dout,//read output data
    // Power signals
    input 	      vss, // ground signal
    input 	      vdd, // memory core array power
    input 	      vddio, // periphery/io power
    // Generic interfaces
    input [CTRLW-1:0] ctrl, // pass through ASIC control interface
    input [TESTW-1:0] test // pass through ASIC test interface
    );

   // Generic RTL RAM
   reg [DW-1:0]       ram    [0:DEPTH-1];
   reg [DW-1:0]       rd_reg;
   wire [DW-1:0]      rdata;
   integer 	      i;

   //write port
   always @(posedge clk)
     for (i=0;i<DW;i=i+1)
       if (ce & we & wmask[i])
         ram[addr[AW-1:0]][i] <= din[i];

   //read port
   assign rdata[DW-1:0] = ram[addr[AW-1:0]];

   //configurable output register
   always @ (posedge clk)
     if(ce)
       rd_reg[DW-1:0] <= rdata[DW-1:0];

   //Drive output from register or RAM directly
   assign dout[DW-1:0] = (REG==1) ? rd_reg[DW-1:0] : rdata[DW-1:0];

endmodule
