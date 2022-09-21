/*****************************************************************************
 * Function: Confiruable Padring Generator
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * - Core ground (vss) is continuous around the ring
 *
 * - Cut cells are inserted as appropriate
 *
 * - Support for analog and digital pins
 *
 * - Supports up to 31 individual sections per side (5 bits)
 *
 * - Supports up to 63 pins per section/side (8 bits)
 *
 * - Per section parameters are stuffed 8bit vectors:
 *    {SECN, SECN-1, ...SEC1, SEC0}
 *
 * - Example: If we have 4 sections (left to right) as seen from
 *            center with a total of 15 pins, with pins in section0=1,
 *            section1=2, section2=4, and section3=8, then we would enter the
 *            "N" parameter would be specified as "parameter:
 *             N = {8'd12, 8'd, 8'd2, 8'd1}"
 *
 ****************************************************************************/

module la_iopadring
  #(// global settings
    parameter CFGW   = 16,        // width of core config bus
    parameter RINGW  = 8,         // width of io ring
    parameter ENCUT  = 1,         // enable cuts at corner
    parameter ENPOC  = 1,         // enable poc cells
    // per side settings
    parameter [7:0]    NO_SECTIONS   =  1,
    parameter [7:0]    NO_N          =  8'h8,
    parameter [2047:0] NO_NSPLIT     =  2048'h08,
    parameter [2047:0] NO_NSTART     =  2048'h00,
    parameter [2047:0] NO_NVDDIO     =  2048'h01,
    parameter [2047:0] NO_NVDD       =  2048'h01,
    parameter [2047:0] NO_NGND       =  2048'h01,
    parameter [2047:0] NO_NCLAMP     =  2048'h00,
    parameter [2047:0] NO_PINSELECT  =  2048'h00,
    parameter [2047:0] NO_IOTYPE     =  2048'h00,
    parameter [2047:0] NO_VDDTYPE    =  2048'h00,
    parameter [2047:0] NO_VSSTYPE    =  2048'h00,
    parameter [2047:0] NO_VDDIOTYPE  =  2048'h00,
    parameter [2047:0] NO_VSSIOTYPE  =  2048'h00,
    parameter [2047:0] NO_CLAMPTYPE  =  2048'h00,
    parameter [2047:0] NO_CUTTYPE    =  2048'h00,
    parameter [2047:0] NO_POCTYPE    =  2048'h00,
    parameter [7:0]    SO_SECTIONS   =  1,
    parameter [7:0]    SO_N          =  8'h8,
    parameter [2047:0] SO_NSPLIT     =  2048'h08,
    parameter [2047:0] SO_NSTART     =  2048'h00,
    parameter [2047:0] SO_NVDDIO     =  2048'h01,
    parameter [2047:0] SO_NVDD       =  2048'h01,
    parameter [2047:0] SO_NGND       =  2048'h01,
    parameter [2047:0] SO_NCLAMP     =  2048'h00,
    parameter [2047:0] SO_PINSELECT  =  2048'h00,
    parameter [2047:0] SO_IOTYPE     =  2048'h00,
    parameter [2047:0] SO_VDDTYPE    =  2048'h00,
    parameter [2047:0] SO_VSSTYPE    =  2048'h00,
    parameter [2047:0] SO_VDDIOTYPE  =  2048'h00,
    parameter [2047:0] SO_VSSIOTYPE  =  2048'h00,
    parameter [2047:0] SO_CLAMPTYPE  =  2048'h00,
    parameter [2047:0] SO_CUTTYPE    =  2048'h00,
    parameter [2047:0] SO_POCTYPE    =  2048'h00,
    parameter [7:0]    EA_SECTIONS   =  1,
    parameter [7:0]    EA_N          =  8'h8,
    parameter [2047:0] EA_NSPLIT     =  2048'h08,
    parameter [2047:0] EA_NSTART     =  2048'h00,
    parameter [2047:0] EA_NVDDIO     =  2048'h01,
    parameter [2047:0] EA_NVDD       =  2048'h01,
    parameter [2047:0] EA_NGND       =  2048'h01,
    parameter [2047:0] EA_NCLAMP     =  2048'h00,
    parameter [2047:0] EA_PINSELECT  =  2048'h00,
    parameter [2047:0] EA_IOTYPE     =  2048'h00,
    parameter [2047:0] EA_VDDTYPE    =  2048'h00,
    parameter [2047:0] EA_VSSTYPE    =  2048'h00,
    parameter [2047:0] EA_VDDIOTYPE  =  2048'h00,
    parameter [2047:0] EA_VSSIOTYPE  =  2048'h00,
    parameter [2047:0] EA_CLAMPTYPE  =  2048'h00,
    parameter [2047:0] EA_CUTTYPE    =  2048'h00,
    parameter [2047:0] EA_POCTYPE    =  2048'h00,
    parameter [7:0]    WE_SECTIONS   =  1,
    parameter [7:0]    WE_N          =  8'h8,
    parameter [2047:0] WE_NSPLIT     =  2048'h08,
    parameter [2047:0] WE_NSTART     =  2048'h00,
    parameter [2047:0] WE_NVDDIO     =  2048'h01,
    parameter [2047:0] WE_NVDD       =  2048'h01,
    parameter [2047:0] WE_NGND       =  2048'h01,
    parameter [2047:0] WE_NCLAMP     =  2048'h00,
    parameter [2047:0] WE_PINSELECT  =  2048'h00,
    parameter [2047:0] WE_IOTYPE     =  2048'h00,
    parameter [2047:0] WE_VDDTYPE    =  2048'h00,
    parameter [2047:0] WE_VSSTYPE    =  2048'h00,
    parameter [2047:0] WE_VDDIOTYPE  =  2048'h00,
    parameter [2047:0] WE_VSSIOTYPE  =  2048'h00,
    parameter [2047:0] WE_CLAMPTYPE  =  2048'h00,
    parameter [2047:0] WE_CUTTYPE    =  2048'h00,
    parameter [2047:0] WE_POCTYPE    =  2048'h00
    )
   (// CONTINUOUS GROUND
    inout 		    vss,
    // NORTH
    inout [NO_N-1:0] 	    no_pad, // pad
    output [NO_N-1:0] 	    no_z, // output to core
    input [NO_N-1:0] 	    no_a, // input from core
    input [NO_N-1:0] 	    no_ie, // input enable, 1 = active
    input [NO_N-1:0] 	    no_oe, // output enable, 1 = active
    input [NO_N*CFGW-1:0]   no_cfg, // generic config interface
    inout [NO_SECTIONS-1:0] no_vdd, // core supply
    inout [NO_SECTIONS-1:0] no_vddio, // io supply
    inout [NO_SECTIONS-1:0] no_vssio, // io ground
    // EAST
    inout [EA_N-1:0] 	    ea_pad, // pad
    output [EA_N-1:0] 	    ea_z, // output to core
    input [EA_N-1:0] 	    ea_a, // input from core
    input [EA_N-1:0] 	    ea_ie, // input enable, 1 = active
    input [EA_N-1:0] 	    ea_oe, // output enable, 1 = active
    input [EA_N*CFGW-1:0]   ea_cfg, // generic config interface
    inout [EA_SECTIONS-1:0] ea_vdd, // core supply
    inout [EA_SECTIONS-1:0] ea_vddio, // io supply
    inout [EA_SECTIONS-1:0] ea_vssio, // io ground
    // SOUTH
    inout [SO_N-1:0] 	    so_pad, // pad
    output [SO_N-1:0] 	    so_z, // output to core
    input [SO_N-1:0] 	    so_a, // input from core
    input [SO_N-1:0] 	    so_ie, // input enable, 1 = active
    input [SO_N-1:0] 	    so_oe, // output enable, 1 = active
    input [SO_N*CFGW-1:0]   so_cfg, // generic config interface
    inout [SO_SECTIONS-1:0] so_vdd, // core supply
    inout [SO_SECTIONS-1:0] so_vddio, // io supply
    inout [SO_SECTIONS-1:0] so_vssio, // io ground
    // WEST
    inout [WE_N-1:0] 	    we_pad, // pad
    output [WE_N-1:0] 	    we_z, // output to core
    input [WE_N-1:0] 	    we_a, // input from core
    input [WE_N-1:0] 	    we_ie, // input enable, 1 = active
    input [WE_N-1:0] 	    we_oe, // output enable, 1 = active
    input [WE_N*CFGW-1:0]   we_cfg, // generic config interface
    inout [WE_SECTIONS-1:0] we_vdd, // core supply
    inout [WE_SECTIONS-1:0] we_vddio, // io supply
    inout [WE_SECTIONS-1:0] we_vssio // io ground
    );

   //#####################
   // LOCAL WIRES
   //#####################

   wire [RINGW-1:0]  no_ioringr;
   wire 	     no_vddior;
   wire 	     no_vssior;
   wire 	     no_vddr;
   wire [RINGW-1:0]  ea_ioringr;
   wire 	     ea_vddior;
   wire 	     ea_vssior;
   wire 	     ea_vddr;
   wire [RINGW-1:0]  so_ioringr;
   wire 	     so_vddior;
   wire 	     so_vssior;
   wire 	     so_vddr;
   wire [RINGW-1:0]  we_ioringr;
   wire 	     we_vddior;
   wire 	     we_vssior;
   wire 	     we_vddr;

   /*AUTOWIRE*/

   //#####################
   // CONNECTION TEMPLATE
   //#####################

   /*la_ioside AUTO_TEMPLATE (//outputs
    .vss	(vss),
    .\(.*\)	(@"(substring vl-cell-name 1 3)"_\1),
    );
    */

   //#####################
   // NORTH
   //#####################

   la_ioside #(// per side
	       .SIDE("NO"),
	       .SECTIONS(NO_SECTIONS),
	       .N(NO_N),
	       //per section
	       .NSTART(NO_NSTART),
	       .NSPLIT(NO_NSPLIT),
	       .NVDDIO(NO_NVDDIO),
	       .NVDD(NO_NVDD),
	       .NGND(NO_NGND),
	       .NCLAMP(NO_NCLAMP),
	       //per pin
	       .PINSELECT(NO_PINSELECT),
	       .IOTYPE(NO_IOTYPE),
	       .VDDTYPE(NO_VDDTYPE),
	       .VSSTYPE(NO_VSSTYPE),
	       .VDDIOTYPE(NO_VDDIOTYPE),
	       .VSSIOTYPE(NO_VSSIOTYPE),
	       .CLAMPTYPE(NO_CLAMPTYPE),
	       .POCTYPE(NO_POCTYPE),
	       .CUTTYPE(NO_CUTTYPE),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT))

   inorth(/*AUTOINST*/
	  // Outputs
	  .z				(no_z),			 // Templated
	  // Inouts
	  .pad				(no_pad),		 // Templated
	  .vss				(vss),			 // Templated
	  .vddr				(no_vddr),		 // Templated
	  .vddior			(no_vddior),		 // Templated
	  .vssior			(no_vssior),		 // Templated
	  .ioringr			(no_ioringr),		 // Templated
	  // Inputs
	  .a				(no_a),			 // Templated
	  .ie				(no_ie),		 // Templated
	  .oe				(no_oe),		 // Templated
	  .cfg				(no_cfg));		 // Templated

   //#####################
   // EAST
   //#####################
   la_ioside #(// per side
	       .SIDE("EA"),
	       .SECTIONS(EA_SECTIONS),
	       .N(EA_N),
	       //per section
	       .NSTART(EA_NSTART),
	       .NSPLIT(EA_NSPLIT),
	       .NVDDIO(EA_NVDDIO),
	       .NVDD(EA_NVDD),
	       .NGND(EA_NGND),
	       .NCLAMP(EA_NCLAMP),
	       //per pin
	       .PINSELECT(EA_PINSELECT),
	       .IOTYPE(EA_IOTYPE),
	       .VDDTYPE(EA_VDDTYPE),
	       .VSSTYPE(EA_VSSTYPE),
	       .VDDIOTYPE(EA_VDDIOTYPE),
	       .VSSIOTYPE(EA_VSSIOTYPE),
	       .CLAMPTYPE(EA_CLAMPTYPE),
	       .POCTYPE(EA_POCTYPE),
	       .CUTTYPE(EA_CUTTYPE),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT))

   ieast(/*AUTOINST*/
	 // Outputs
	 .z				(ea_z),			 // Templated
	 // Inouts
	 .pad				(ea_pad),		 // Templated
	 .vss				(vss),			 // Templated
	 .vddr				(ea_vddr),		 // Templated
	 .vddior			(ea_vddior),		 // Templated
	 .vssior			(ea_vssior),		 // Templated
	 .ioringr			(ea_ioringr),		 // Templated
	 // Inputs
	 .a				(ea_a),			 // Templated
	 .ie				(ea_ie),		 // Templated
	 .oe				(ea_oe),		 // Templated
	 .cfg				(ea_cfg));		 // Templated

   //#####################
   // SOUTH
   //#####################

   la_ioside #(// per side
	       .SIDE("SO"),
	       .SECTIONS(SO_SECTIONS),
	       .N(SO_N),
	       //per section
	       .NSTART(SO_NSTART),
	       .NSPLIT(SO_NSPLIT),
	       .NVDDIO(SO_NVDDIO),
	       .NVDD(SO_NVDD),
	       .NGND(SO_NGND),
	       .NCLAMP(SO_NCLAMP),
	       //per pin
	       .PINSELECT(SO_PINSELECT),
	       .IOTYPE(SO_IOTYPE),
	       .VDDTYPE(SO_VDDTYPE),
	       .VSSTYPE(SO_VSSTYPE),
	       .VDDIOTYPE(SO_VDDIOTYPE),
	       .VSSIOTYPE(SO_VSSIOTYPE),
	       .CLAMPTYPE(SO_CLAMPTYPE),
	       .POCTYPE(SO_POCTYPE),
	       .CUTTYPE(SO_CUTTYPE),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT))

   isouth(/*AUTOINST*/
	  // Outputs
	  .z				(so_z),			 // Templated
	  // Inouts
	  .pad				(so_pad),		 // Templated
	  .vss				(vss),			 // Templated
	  .vddr				(so_vddr),		 // Templated
	  .vddior			(so_vddior),		 // Templated
	  .vssior			(so_vssior),		 // Templated
	  .ioringr			(so_ioringr),		 // Templated
	  // Inputs
	  .a				(so_a),			 // Templated
	  .ie				(so_ie),		 // Templated
	  .oe				(so_oe),		 // Templated
	  .cfg				(so_cfg));		 // Templated

   //#####################
   // WEST
   //#####################

   la_ioside #(// per side
	       .SIDE("WE"),
	       .SECTIONS(WE_SECTIONS),
	       .N(WE_N),
	       //per section
	       .NSTART(WE_NSTART),
	       .NSPLIT(WE_NSPLIT),
	       .NVDDIO(WE_NVDDIO),
	       .NVDD(WE_NVDD),
	       .NGND(WE_NGND),
	       .NCLAMP(WE_NCLAMP),
	       //per pin
	       .PINSELECT(WE_PINSELECT),
	       .IOTYPE(WE_IOTYPE),
	       .VDDTYPE(WE_VDDTYPE),
	       .VSSTYPE(WE_VSSTYPE),
	       .VDDIOTYPE(WE_VDDIOTYPE),
	       .VSSIOTYPE(WE_VSSIOTYPE),
	       .CLAMPTYPE(WE_CLAMPTYPE),
	       .POCTYPE(WE_POCTYPE),
	       .CUTTYPE(WE_CUTTYPE),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT))


   iwest(/*AUTOINST*/
	 // Outputs
	 .z				(we_z),			 // Templated
	 // Inouts
	 .pad				(we_pad),		 // Templated
	 .vss				(vss),			 // Templated
	 .vddr				(we_vddr),		 // Templated
	 .vddior			(we_vddior),		 // Templated
	 .vssior			(we_vssior),		 // Templated
	 .ioringr			(we_ioringr),		 // Templated
	 // Inputs
	 .a				(we_a),			 // Templated
	 .ie				(we_ie),		 // Templated
	 .oe				(we_oe),		 // Templated
	 .cfg				(we_cfg));		 // Templated

endmodule // la_iopadring
// Local Variables:
// verilog-library-directories:("." "../stub")
// End:
