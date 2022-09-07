/*****************************************************************************
 * Function: Confiruable Padring Generator
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * - Core ground (vss) is continuous around the ring
 * - Cut cells are inserted as appropriate
 * - Support for analog and digital pins
 *
 ****************************************************************************/

module la_iopadring
  #(// global settings
    parameter [7:0]  CFGW   = 8,         // width of core config bus
    parameter [7:0]  RINGW  = 8,         // width of io ring
    parameter [0:0]  ENCUT  = 1,         // enable cuts at corner
    parameter [0:0]  ENPOC  = 1,         // enable poc cells
    // optional overrides of default lib
    parameter IOTYPE        = "DEFAULT", // io cell type
    parameter XTALTYPE      = "DEFAULT", // io cell type
    parameter ANALOGTYPE    = "DEFAULT", // io cell type
    parameter POCTYPE       = "DEFAULT", // poc cell type
    parameter VDDTYPE       = "DEFAULT", // vdd cell type
    parameter VDDIOTYPE     = "DEFAULT", // vddio cell type
    parameter VSSIOTYPE     = "DEFAULT", // vssio cell type
    parameter VSSTYPE       = "DEFAULT", // vss cell type
    // per side settings (total, split up to recipe)
    parameter [4:0]  NO_SECTIONS =  1,
    parameter [7:0]  NO_NSIDE    =  8'h8,
    parameter [63:0] NO_N        =  64'h0404,
    parameter [63:0] NO_NSEL     =  64'h0,
    parameter [63:0] NO_NSTART   =  64'h00,
    parameter [63:0] NO_NVDDIO   =  64'h01,
    parameter [63:0] NO_NVDD     =  64'h01,
    parameter [63:0] NO_NGND     =  64'h01,
    parameter [63:0] NO_NCLAMP   =  64'h01,
    parameter [4:0]  EA_SECTIONS =  1,
    parameter [7:0]  EA_NSIDE    =  8'h8,
    parameter [63:0] EA_N        =  64'h08,
    parameter [63:0] EA_NSEL     =  64'h0,
    parameter [63:0] EA_NSTART   =  64'h00,
    parameter [63:0] EA_NVDDIO   =  64'h01,
    parameter [63:0] EA_NVDD     =  64'h01,
    parameter [63:0] EA_NGND     =  64'h01,
    parameter [63:0] EA_NCLAMP   =  64'h00,
    parameter [4:0]  SO_SECTIONS =  1,
    parameter [7:0]  SO_NSIDE    =  8'h8,
    parameter [63:0] SO_N        =  64'h08,
    parameter [63:0] SO_NSEL     =  64'h0,
    parameter [63:0] SO_NSTART   =  64'h00,
    parameter [63:0] SO_NVDDIO   =  64'h01,
    parameter [63:0] SO_NVDD     =  64'h01,
    parameter [63:0] SO_NGND     =  64'h01,
    parameter [63:0] SO_NCLAMP   =  64'h00,
    parameter [4:0]  WE_SECTIONS =  1,
    parameter [7:0]  WE_NSIDE    =  8'h8,
    parameter [63:0] WE_N        =  64'h08,
    parameter [63:0] WE_NSEL     =  64'h0,
    parameter [63:0] WE_NSTART   =  64'h00,
    parameter [63:0] WE_NVDDIO   =  64'h01,
    parameter [63:0] WE_NVDD     =  64'h01,
    parameter [63:0] WE_NGND     =  64'h01,
    parameter [63:0] WE_NCLAMP   =  64'h00
    )
   (//CONTINUOUS GROUND
    inout 		      vss,
    // NORTH
    inout [NO_NSIDE-1:0]      no_pad, // pad
    output [NO_NSIDE-1:0]     no_z, // output to core
    input [NO_NSIDE-1:0]      no_a, // input from core
    input [NO_NSIDE-1:0]      no_ie, // input enable, 1 = active
    input [NO_NSIDE-1:0]      no_oe, // output enable, 1 = active
    input [NO_NSIDE-1:0]      no_pe, // pullup enable, 1 = active
    input [NO_NSIDE-1:0]      no_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [NO_NSIDE-1:0]      no_sr, // slewrate enable 1 = slow, 1 = fast
    input [NO_NSIDE-1:0]      no_st, // schmitt trigger, 1 = enable
    input [NO_NSIDE*3-1:0]    no_ds, // drive strength, 3'b0 = weakest
    input [NO_NSIDE*CFGW-1:0] no_cfg, // generic config interface
    inout [NO_SECTIONS-1:0]   no_vdd, // core supply
    inout [NO_SECTIONS-1:0]   no_vddio, // io supply
    inout [NO_SECTIONS-1:0]   no_vssio, // io ground
    // EAST
    inout [EA_NSIDE-1:0]      ea_pad, // pad
    output [EA_NSIDE-1:0]     ea_z, // output to core
    input [EA_NSIDE-1:0]      ea_a, // input from core
    input [EA_NSIDE-1:0]      ea_ie, // input enable, 1 = active
    input [EA_NSIDE-1:0]      ea_oe, // output enable, 1 = active
    input [EA_NSIDE-1:0]      ea_pe, // pullup enable, 1 = active
    input [EA_NSIDE-1:0]      ea_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [EA_NSIDE-1:0]      ea_sr, // slewrate enable 1 = slow, 1 = fast
    input [EA_NSIDE-1:0]      ea_st, // schmitt trigger, 1 = enable
    input [EA_NSIDE*3-1:0]    ea_ds, // drive strength, 3'b0 = weakest
    input [EA_NSIDE*CFGW-1:0] ea_cfg, // generic config interface
    inout [EA_SECTIONS-1:0]   ea_vdd, // core supply
    inout [EA_SECTIONS-1:0]   ea_vddio, // io supply
    inout [EA_SECTIONS-1:0]   ea_vssio, // io ground
    // SOUTH
    inout [SO_NSIDE-1:0]      so_pad, // pad
    output [SO_NSIDE-1:0]     so_z, // output to core
    input [SO_NSIDE-1:0]      so_a, // input from core
    input [SO_NSIDE-1:0]      so_ie, // input enable, 1 = active
    input [SO_NSIDE-1:0]      so_oe, // output enable, 1 = active
    input [SO_NSIDE-1:0]      so_pe, // pullup enable, 1 = active
    input [SO_NSIDE-1:0]      so_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [SO_NSIDE-1:0]      so_sr, // slewrate enable 1 = slow, 1 = fast
    input [SO_NSIDE-1:0]      so_st, // schmitt trigger, 1 = enable
    input [SO_NSIDE*3-1:0]    so_ds, // drive strength, 3'b0 = weakest
    input [SO_NSIDE*CFGW-1:0] so_cfg, // generic config interface
    inout [SO_SECTIONS-1:0]   so_vdd, // core supply
    inout [SO_SECTIONS-1:0]   so_vddio, // io supply
    inout [SO_SECTIONS-1:0]   so_vssio, // io ground
    // WEST
    inout [WE_NSIDE-1:0]      we_pad, // pad
    output [WE_NSIDE-1:0]     we_z, // output to core
    input [WE_NSIDE-1:0]      we_a, // input from core
    input [WE_NSIDE-1:0]      we_ie, // input enable, 1 = active
    input [WE_NSIDE-1:0]      we_oe, // output enable, 1 = active
    input [WE_NSIDE-1:0]      we_pe, // pullup enable, 1 = active
    input [WE_NSIDE-1:0]      we_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [WE_NSIDE-1:0]      we_sr, // slewrate enable 1 = slow, 1 = fast
    input [WE_NSIDE-1:0]      we_st, // schmitt trigger, 1 = enable
    input [WE_NSIDE*3-1:0]    we_ds, // drive strength, 3'b0 = weakest
    input [WE_NSIDE*CFGW-1:0] we_cfg, // generic config interface
    inout [WE_SECTIONS-1:0]   we_vdd, // core supply
    inout [WE_SECTIONS-1:0]   we_vddio, // io supply
    inout [WE_SECTIONS-1:0]   we_vssio // io ground
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
	       .NSIDE(NO_NSIDE),
	       .N(NO_N),
	       .NSEL(NO_NSEL),
	       .NSTART(NO_NSTART),
	       .NVDDIO(NO_NVDDIO),
	       .NVDD(NO_NVDD),
	       .NGND(NO_NGND),
	       .NCLAMP(NO_NCLAMP),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT),
	       // optional
	       .IOTYPE(IOTYPE),
	       .ANALOGTYPE(ANALOGTYPE),
	       .XTALTYPE(XTALTYPE),
	       .POCTYPE(POCTYPE),
	       .VDDTYPE(VDDTYPE),
	       .VDDIOTYPE(VDDIOTYPE),
	       .VSSIOTYPE(VSSIOTYPE),
	       .VSSTYPE(VSSTYPE))

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
	  .pe				(no_pe),		 // Templated
	  .ps				(no_ps),		 // Templated
	  .sr				(no_sr),		 // Templated
	  .st				(no_st),		 // Templated
	  .ds				(no_ds),		 // Templated
	  .cfg				(no_cfg));		 // Templated

   //#####################
   // EAST
   //#####################
   la_ioside #(// per side
	       .SIDE("EA"),
	       .SECTIONS(EA_SECTIONS),
	       .NSIDE(EA_NSIDE),
	       .N(EA_N),
	       .NSEL(EA_NSEL),
	       .NSTART(EA_NSTART),
	       .NVDDIO(EA_NVDDIO),
	       .NVDD(EA_NVDD),
	       .NGND(EA_NGND),
	       .NCLAMP(EA_NCLAMP),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT),
	       // optional
	       .IOTYPE(IOTYPE),
	       .ANALOGTYPE(ANALOGTYPE),
	       .XTALTYPE(XTALTYPE),
	       .POCTYPE(POCTYPE),
	       .VDDTYPE(VDDTYPE),
	       .VDDIOTYPE(VDDIOTYPE),
	       .VSSIOTYPE(VSSIOTYPE),
	       .VSSTYPE(VSSTYPE))

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
	 .pe				(ea_pe),		 // Templated
	 .ps				(ea_ps),		 // Templated
	 .sr				(ea_sr),		 // Templated
	 .st				(ea_st),		 // Templated
	 .ds				(ea_ds),		 // Templated
	 .cfg				(ea_cfg));		 // Templated

   //#####################
   // SOUTH
   //#####################

   la_ioside #(// per side
	       .SIDE("SO"),
	       .SECTIONS(SO_SECTIONS),
	       .NSIDE(SO_NSIDE),
	       .N(SO_N),
	       .NSEL(SO_NSEL),
	       .NSTART(SO_NSTART),
	       .NVDDIO(SO_NVDDIO),
	       .NVDD(SO_NVDD),
	       .NGND(SO_NGND),
	       .NCLAMP(SO_NCLAMP),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT),
	       // optional
	       .IOTYPE(IOTYPE),
	       .ANALOGTYPE(ANALOGTYPE),
	       .XTALTYPE(XTALTYPE),
	       .POCTYPE(POCTYPE),
	       .VDDTYPE(VDDTYPE),
	       .VDDIOTYPE(VDDIOTYPE),
	       .VSSIOTYPE(VSSIOTYPE),
	       .VSSTYPE(VSSTYPE))

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
	  .pe				(so_pe),		 // Templated
	  .ps				(so_ps),		 // Templated
	  .sr				(so_sr),		 // Templated
	  .st				(so_st),		 // Templated
	  .ds				(so_ds),		 // Templated
	  .cfg				(so_cfg));		 // Templated

   //#####################
   // WEST
   //#####################NO_

   la_ioside #(// per side
	       .SIDE("WE"),
	       .SECTIONS(WE_SECTIONS),
	       .NSIDE(WE_NSIDE),
	       .N(WE_N),
	       .NSEL(WE_NSEL),
	       .NSTART(WE_NSTART),
	       .NVDDIO(WE_NVDDIO),
	       .NVDD(WE_NVDD),
	       .NGND(WE_NGND),
	       .NCLAMP(WE_NCLAMP),
	       // globals
	       .CFGW(CFGW),
	       .RINGW(RINGW),
	       .ENPOC(ENPOC),
	       .ENRCUT(ENCUT),
	       .ENLCUT(ENCUT),
	       // optional
	       .IOTYPE(IOTYPE),
	       .ANALOGTYPE(ANALOGTYPE),
	       .XTALTYPE(XTALTYPE),
	       .POCTYPE(POCTYPE),
	       .VDDTYPE(VDDTYPE),
	       .VDDIOTYPE(VDDIOTYPE),
	       .VSSIOTYPE(VSSIOTYPE),
	       .VSSTYPE(VSSTYPE))

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
	 .pe				(we_pe),		 // Templated
	 .ps				(we_ps),		 // Templated
	 .sr				(we_sr),		 // Templated
	 .st				(we_st),		 // Templated
	 .ds				(we_ds),		 // Templated
	 .cfg				(we_cfg));		 // Templated

endmodule // la_iopadring
// Local Variables:
// verilog-library-directories:("." "../stub")
// End:
