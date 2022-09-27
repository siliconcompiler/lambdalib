/*****************************************************************************
 * Function: Padframe Generator
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * - Cround (vss) is continuous around the while chip.
 *
 * - Default is for ioring to be cut at corners, user must short rings
 *   at top level in RTl/netlist if abutted ring extends across corners.
 *
 * - CELLMAP = {SECTION#, PIN#, CELLTYPE}
 *
 * - SECTION specifies which power domain the pin belongs to
 *
 * - PIN maps the cell to the pin number
 *
 * - CELLTYPE[3:0] specifies the cell type (see la_iopadring.vh)
 *
 * - CELLTYPE[7:4] is used by inside lambda cells for selection
 *
 ****************************************************************************/

module la_iopadring
  #(// global settings
    parameter           CFGW         = 8,        // width of config bus
    parameter           RINGW        = 8,        // width of io ring
    // per side settings
    parameter NO_NPINS     =  0, // IO pins per side
    parameter NO_NCELLS    =  0, // cells per side
    parameter NO_NSECTIONS =  0, // sections per side
    parameter NO_CELLMAP   =  0, // type per cell
    parameter EA_NPINS     =  0, // IO pins per side
    parameter EA_NCELLS    =  0, // cells per side
    parameter EA_NSECTIONS =  0, // sections per side
    parameter EA_CELLMAP   =  0, // type per cell
    parameter SO_NPINS     =  0, // IO pins per side
    parameter SO_NCELLS    =  0, // cells per side
    parameter SO_NSECTIONS =  0, // sections per side
    parameter SO_CELLMAP   =  0, // type per cell
    parameter WE_NPINS     =  0, // IO pins per side
    parameter WE_NCELLS    =  0, // cells per side
    parameter WE_NSECTIONS =  0, // sections per side
    parameter WE_CELLMAP   =  0  // type per cell
    )
   (// CONTINUOUS GROUND
    inout 			   vss,
    // NORTH
    inout [NO_NPINS-1:0] 	   no_pad, // pad
    inout [NO_NPINS*3-1:0] 	   no_aio, // analog inout
    output [NO_NPINS-1:0] 	   no_z, // output to core
    input [NO_NPINS-1:0] 	   no_a, // input from core
    input [NO_NPINS-1:0] 	   no_ie, // input enable, 1 = active
    input [NO_NPINS-1:0] 	   no_oe, // output enable, 1 = active
    input [NO_NPINS*CFGW-1:0] 	   no_cfg, // generic config interface
    inout [NO_NSECTIONS-1:0] 	   no_vdd, // core supply
    inout [NO_NSECTIONS-1:0] 	   no_vddio, // io/analog supply
    inout [NO_NSECTIONS-1:0] 	   no_vssio, // io/analog ground
    inout [NO_NSECTIONS*RINGW-1:0] no_ioring, // io ring
    // EAST
    inout [EA_NPINS-1:0] 	   ea_pad, // pad
    inout [EA_NPINS*3-1:0] 	   ea_aio, // analog inout
    output [EA_NPINS-1:0] 	   ea_z, // output to core
    input [EA_NPINS-1:0] 	   ea_a, // input from core
    input [EA_NPINS-1:0] 	   ea_ie, // input enable, 1 = active
    input [EA_NPINS-1:0] 	   ea_oe, // output enable, 1 = active
    input [EA_NPINS*CFGW-1:0] 	   ea_cfg, // generic config interface
    inout [EA_NSECTIONS-1:0] 	   ea_vdd, // core supply
    inout [EA_NSECTIONS-1:0] 	   ea_vddio, // io supply
    inout [EA_NSECTIONS-1:0] 	   ea_vssio, // io ground
    inout [EA_NSECTIONS*RINGW-1:0] ea_ioring, // io ring
    // SOUTH
    inout [SO_NPINS-1:0] 	   so_pad, // pad
    inout [SO_NPINS*3-1:0] 	   so_aio, // analog inout
    output [SO_NPINS-1:0] 	   so_z, // output to core
    input [SO_NPINS-1:0] 	   so_a, // input from core
    input [SO_NPINS-1:0] 	   so_ie, // input enable, 1 = active
    input [SO_NPINS-1:0] 	   so_oe, // output enable, 1 = active
    input [SO_NPINS*CFGW-1:0] 	   so_cfg, // generic config interface
    inout [SO_NSECTIONS-1:0] 	   so_vdd, // core supply
    inout [SO_NSECTIONS-1:0] 	   so_vddio, // io supply
    inout [SO_NSECTIONS-1:0] 	   so_vssio, // io ground
    inout [SO_NSECTIONS*RINGW-1:0] so_ioring, // io ring
    // WEST
    inout [WE_NPINS-1:0] 	   we_pad, // pad
    inout [WE_NPINS*3-1:0] 	   we_aio, // analog inout
    output [WE_NPINS-1:0] 	   we_z, // output to core
    input [WE_NPINS-1:0] 	   we_a, // input from core
    input [WE_NPINS-1:0] 	   we_ie, // input enable, 1 = active
    input [WE_NPINS-1:0] 	   we_oe, // output enable, 1 = active
    input [WE_NPINS*CFGW-1:0] 	   we_cfg, // generic config interface
    inout [WE_NSECTIONS-1:0] 	   we_vdd, // core supply
    inout [WE_NSECTIONS-1:0] 	   we_vddio, // io supply
    inout [WE_NSECTIONS-1:0] 	   we_vssio, // io ground
    inout [WE_NSECTIONS*RINGW-1:0] we_ioring // io ring
    );



   //#####################
   // LOCAL WIRES
   //#####################
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

   la_ioside #(.SIDE("NO"),
	       .NPINS(NO_NPINS),
	       .NCELLS(NO_NCELLS),
	       .NSECTIONS(NO_NSECTIONS),
	       .CELLMAP(NO_CELLMAP),
	       .RINGW(RINGW),
	       .CFGW(CFGW))
   inorth(/*AUTOINST*/
	  // Outputs
	  .z				(no_z),			 // Templated
	  // Inouts
	  .pad				(no_pad),		 // Templated
	  .aio				(no_aio),		 // Templated
	  .vss				(vss),			 // Templated
	  .vdd				(no_vdd),		 // Templated
	  .vddio			(no_vddio),		 // Templated
	  .vssio			(no_vssio),		 // Templated
	  .ioring			(no_ioring),		 // Templated
	  // Inputs
	  .a				(no_a),			 // Templated
	  .ie				(no_ie),		 // Templated
	  .oe				(no_oe),		 // Templated
	  .cfg				(no_cfg));		 // Templated

   //#####################
   // EAST
   //#####################
   la_ioside #(.SIDE("EA"),
	       .NPINS(EA_NPINS),
	       .NCELLS(EA_NCELLS),
	       .NSECTIONS(EA_NSECTIONS),
	       .CELLMAP(EA_CELLMAP),
	       .RINGW(RINGW),
	       .CFGW(CFGW))
   ieast(/*AUTOINST*/
	 // Outputs
	 .z				(ea_z),			 // Templated
	 // Inouts
	 .pad				(ea_pad),		 // Templated
	 .aio				(ea_aio),		 // Templated
	 .vss				(vss),			 // Templated
	 .vdd				(ea_vdd),		 // Templated
	 .vddio				(ea_vddio),		 // Templated
	 .vssio				(ea_vssio),		 // Templated
	 .ioring			(ea_ioring),		 // Templated
	 // Inputs
	 .a				(ea_a),			 // Templated
	 .ie				(ea_ie),		 // Templated
	 .oe				(ea_oe),		 // Templated
	 .cfg				(ea_cfg));		 // Templated

   //#####################
   // SOUTH
   //#####################

   la_ioside #(.SIDE("SO"),
	       .NPINS(SO_NPINS),
	       .NCELLS(SO_NCELLS),
	       .NSECTIONS(SO_NSECTIONS),
	       .CELLMAP(SO_CELLMAP),
	       .RINGW(RINGW),
	       .CFGW(CFGW))
   isouth(/*AUTOINST*/
	  // Outputs
	  .z				(so_z),			 // Templated
	  // Inouts
	  .pad				(so_pad),		 // Templated
	  .aio				(so_aio),		 // Templated
	  .vss				(vss),			 // Templated
	  .vdd				(so_vdd),		 // Templated
	  .vddio			(so_vddio),		 // Templated
	  .vssio			(so_vssio),		 // Templated
	  .ioring			(so_ioring),		 // Templated
	  // Inputs
	  .a				(so_a),			 // Templated
	  .ie				(so_ie),		 // Templated
	  .oe				(so_oe),		 // Templated
	  .cfg				(so_cfg));		 // Templated

   //#####################
   // WEST
   //#####################

   la_ioside #(.SIDE("WE"),
	       .NPINS(WE_NPINS),
	       .NCELLS(WE_NCELLS),
	       .NSECTIONS(WE_NSECTIONS),
	       .CELLMAP(WE_CELLMAP),
	       .RINGW(RINGW),
	       .CFGW(CFGW))
   iwest(/*AUTOINST*/
	 // Outputs
	 .z				(we_z),			 // Templated
	 // Inouts
	 .pad				(we_pad),		 // Templated
	 .aio				(we_aio),		 // Templated
	 .vss				(vss),			 // Templated
	 .vdd				(we_vdd),		 // Templated
	 .vddio				(we_vddio),		 // Templated
	 .vssio				(we_vssio),		 // Templated
	 .ioring			(we_ioring),		 // Templated
	 // Inputs
	 .a				(we_a),			 // Templated
	 .ie				(we_ie),		 // Templated
	 .oe				(we_oe),		 // Templated
	 .cfg				(we_cfg));		 // Templated


endmodule // la_iopadring
// Local Variables:
// verilog-library-directories:(".")
// End:
