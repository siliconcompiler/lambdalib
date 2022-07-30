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
    parameter RINGTYPE    = "DEFAULT", // symmetrical multi section by default
    parameter CFGW        = 8,         // width of core config bus
    parameter RINGW       = 8,         // width of io ring
    parameter ENPOC       = 1,         // enable poc per section
    // optional overrides of default lib
    parameter IOTYPE     = "DEFAULT", // io cell type
    parameter XTALTYPE   = "DEFAULT", // io cell type
    parameter ANALOGTYPE = "DEFAULT", // io cell type
    parameter POCTYPE    = "DEFAULT", // poc cell type
    parameter VDDTYPE    = "DEFAULT", // vdd cell type
    parameter VDDIOTYPE  = "DEFAULT", // vddio cell type
    parameter VSSIOTYPE  = "DEFAULT", // vssio cell type
    parameter VSSTYPE    = "DEFAULT", // vss cell type
    // per side settings
    parameter NO_SECTIONS =  1, // north
    parameter NO_N        =  1,
    parameter NO_ANALOG   =  0,
    parameter NO_NXTAL    =  0,
    parameter NO_NVDDIO   =  1,
    parameter NO_NVDD     =  1,
    parameter NO_NGND     =  1,
    parameter NO_CLAMP    =  0,
    parameter EA_SECTIONS =  1, // east
    parameter EA_N        =  1,
    parameter EA_ANALOG   =  0,
    parameter EA_NXTAL    =  0,
    parameter EA_NVDDIO   =  1,
    parameter EA_NVDD     =  1,
    parameter EA_NGND     =  1,
    parameter EA_CLAMP    =  0,
    parameter EA_SECTIONS =  1, // south
    parameter SO_N        =  1,
    parameter SO_ANALOG   =  0,
    parameter SO_NXTAL    =  0,
    parameter SO_NVDDIO   =  0,
    parameter SO_NVDD     =  1,
    parameter SO_NGND     =  1,
    parameter SO_CLAMP    =  0,
    parameter WE_SECTIONS =  1, // west
    parameter WE_N        =  1,
    parameter WE_ANALOG   =  0,
    parameter WE_NXTAL    =  0,
    parameter WE_NVDDIO   =  1,
    parameter WE_NVDD     =  1,
    parameter WE_NGND     =  1,
    parameter WE_CLAMP    =  0
    )
   (//CONTINUOUS GROUND
    inout 			       vss,
    // NORTH
    inout [NO_SECTIONS*NO_N-1:0]       no_pad, // pad
    output [NO_SECTIONS*NO_N-1:0]      no_z, // output to core
    input [NO_SECTIONS*NO_N-1:0]       no_a, // input from core
    input [NO_SECTIONS*NO_N-1:0]       no_ie, // input enable, 1 = active
    input [NO_SECTIONS*NO_N-1:0]       no_oe, // output enable, 1 = active
    input [NO_SECTIONS*NO_N-1:0]       no_pe, // pullup enable, 1 = active
    input [NO_SECTIONS*NO_N-1:0]       no_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [NO_SECTIONS*NO_N-1:0]       no_sr, // slewrate enable 1 = slow, 1 = fast
    input [NO_SECTIONS*NO_N-1:0]       no_st, // schmitt trigger, 1 = enable
    input [NO_SECTIONS*NO_N*3-1:0]     no_ds, // drive strength, 3'b0 = weakest
    input [NO_SECTIONS*NO_N*CFGW-1:0]  no_cfg, // generic config interface
    inout [NO_SECTIONS-1:0] 	       no_vdd, // core supply
    inout [NO_SECTIONS-1:0] 	       no_vddio, // io supply
    inout [NO_SECTIONS-1:0] 	       no_vssio, // io ground
    inout [NO_SECTIONS*RINGW-1:0]      no_ioring, // generic io-ring
    // EAST
    inout [EA_SECTIONS*EA_N-1:0]       ea_pad, // pad
    output [EA_SECTIONS*EA_N-1:0]      ea_z, // output to core
    input [EA_SECTIONS*EA_N-1:0]       ea_a, // input from core
    input [EA_SECTIONS*EA_N-1:0]       ea_ie, // input enable, 1 = active
    input [EA_SECTIONS*EA_N-1:0]       ea_oe, // output enable, 1 = active
    input [EA_SECTIONS*EA_N-1:0]       ea_pe, // pullup enable, 1 = active
    input [EA_SECTIONS*EA_N-1:0]       ea_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [EA_SECTIONS*EA_N-1:0]       ea_sr, // slewrate enable 1 = slow, 1 = fast
    input [EA_SECTIONS*EA_N-1:0]       ea_st, // schmitt trigger, 1 = enable
    input [EA_SECTIONS*EA_N*3-1:0]     ea_ds, // drive strength, 3'b0 = weakest
    input [EA_SECTIONS*EA_N*CFGW-1:0]  ea_cfg, // generic config interface
    inout [EA_SECTIONS-1:0] 	       ea_vdd, // core supply
    inout [EA_SECTIONS-1:0] 	       ea_vddio, // io supply
    inout [EA_SECTIONS-1:0] 	       ea_vssio, // io ground
    inout [EA_SECTIONS*RINGW-1:0]      ea_ioring, // generic io-ring
    // SOUTH
    inout [SO_SECTIONS*SO_N-1:0]       so_pad, // pad
    output [SO_SECTIONS*SO_N-1:0]      so_z, // output to core
    input [SO_SECTIONS*SO_N-1:0]       so_a, // input from core
    input [SO_SECTIONS*SO_N-1:0]       so_ie, // input enable, 1 = active
    input [SO_SECTIONS*SO_N-1:0]       so_oe, // output enable, 1 = active
    input [SO_SECTIONS*SO_N-1:0]       so_pe, // pullup enable, 1 = active
    input [SO_SECTIONS*SO_N-1:0]       so_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [SO_SECTIONS*SO_N-1:0]       so_sr, // slewrate enable 1 = slow, 1 = fast
    input [SO_SECTIONS*SO_N-1:0]       so_st, // schmitt trigger, 1 = enable
    input [SO_SECTIONS*SO_N*3-1:0]     so_ds, // drive strength, 3'b0 = weakest
    input [SO_SECTIONS*SO_N*CFGW-1:0]  so_cfg, // generic config interface
    inout [SO_SECTIONS-1:0] 	       so_vdd, // core supply
    inout [SO_SECTIONS-1:0] 	       so_vddio, // io supply
    inout [SO_SECTIONS-1:0] 	       so_vssio, // io ground
    inout [SO_SECTIONS*RINGW-1:0]      so_ioring, // generic io-ring
    // WEST
    inout [WE_SECTIONS*WE_N-1:0]       we_pad, // pad
    output [WE_SECTIONS*WE_N-1:0]      we_z, // output to core
    input [WE_SECTIONS*WE_N-1:0]       we_a, // input from core
    input [WE_SECTIONS*WE_N-1:0]       we_ie, // input enable, 1 = active
    input [WE_SECTIONS*WE_N-1:0]       we_oe, // output enable, 1 = active
    input [WE_SECTIONS*WE_N-1:0]       we_pe, // pullup enable, 1 = active
    input [WE_SECTIONS*WE_N-1:0]       we_ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [WE_SECTIONS*WE_N-1:0]       we_sr, // slewrate enable 1 = slow, 1 = fast
    input [WE_SECTIONS*WE_N-1:0]       we_st, // schmitt trigger, 1 = enable
    input [WE_SECTIONS*WE_N*3-1:0]     we_ds, // drive strength, 3'b0 = weakest
    input [WE_SECTIONS*WE_N*CFGW-1:0]  we_cfg, // generic config interface
    inout [WE_SECTIONS-1:0] 	       we_vdd, // core supply
    inout [WE_SECTIONS-1:0] 	       we_vddio, // io supply
    inout [WE_SECTIONS-1:0] 	       we_vssio, // io ground
    inout [WE_SECTIONS*RINGW-1:0]      we_ioring // generic io-ring
    );

   //##########################
   // Symmetrical ioring
   // #########################
   if (GENERATE=="DEFAULT")
     begin
	/*la_ioside AUTO_TEMPLATE (//outputs
	 .vss			(no_vss),
	 .\(.*\)	  (@"(substring vl-cell-name 1 3)"_\1),
	 );
	 */

	//#############################
	// NORTH
	//#############################

	la_ioside #(
		    // per side
		    .SIDE("NO"),
		    .N(NO_N),
		    .NANALOG(NO_NANALOG),
		    .NXTAL(NO_NXTAL),
		    .NVDDIO(NO_VDDIO),
		    .NVDD(NO_NVDD),
		    .NGND(NO_NGND),
		    .NCLAMP(NO_NCLAMP),
		    // globals
		    .CFGW(CFGW),
		    .RINGW(RINGW),
		    .ENPOC(ENPOC),
		    // optional
		    .IOTYPE(IOTYPE),
		    .ANALOGTYPE(ANALOGTYPE),
		    .XTALTYPE(XTALTYPE),
		    .POCTYPE(POCTYPE),
		    .VDDTYPE(VDDTYPE),
		    .VDDIOTYPE(VDDIOTYPE),
		    .VSSIOTYPE(VSSIOTYPE),
		    .VSSTYPE(VSSTYPE)

)


	inorth(/*AUTOINST*/
	       // Outputs
	       .z			(no_z),			 // Templated
	       // Inouts
	       .pad			(no_pad),		 // Templated
	       .vss			(no_vss),		 // Templated
	       .vdd			(no_vdd),		 // Templated
	       .vddio			(no_vddio),		 // Templated
	       .vssio			(no_vssio),		 // Templated
	       .ioring			(no_ioring),		 // Templated
	       .vddl			(no_vddl),		 // Templated
	       .vddiol			(no_vddiol),		 // Templated
	       .vssiol			(no_vssiol),		 // Templated
	       .ioringl			(no_ioringl),		 // Templated
	       .vddr			(no_vddr),		 // Templated
	       .vddior			(no_vddior),		 // Templated
	       .vssior			(no_vssior),		 // Templated
	       .ioringr			(no_ioringr),		 // Templated
	       // Inputs
	       .a			(no_a),			 // Templated
	       .ie			(no_ie),		 // Templated
	       .oe			(no_oe),		 // Templated
	       .pe			(no_pe),		 // Templated
	       .ps			(no_ps),		 // Templated
	       .sr			(no_sr),		 // Templated
	       .st			(no_st),		 // Templated
	       .ds			(no_ds),		 // Templated
	       .cfg			(no_cfg));		 // Templated


	//#############################
	// EAST
	//#############################

	la_ioside ieast(/*AUTOINST*/
			// Outputs
			.z		(ea_z),			 // Templated
			// Inouts
			.pad		(ea_pad),		 // Templated
			.vss		(no_vss),		 // Templated
			.vdd		(ea_vdd),		 // Templated
			.vddio		(ea_vddio),		 // Templated
			.vssio		(ea_vssio),		 // Templated
			.ioring		(ea_ioring),		 // Templated
			.vddl		(ea_vddl),		 // Templated
			.vddiol		(ea_vddiol),		 // Templated
			.vssiol		(ea_vssiol),		 // Templated
			.ioringl	(ea_ioringl),		 // Templated
			.vddr		(ea_vddr),		 // Templated
			.vddior		(ea_vddior),		 // Templated
			.vssior		(ea_vssior),		 // Templated
			.ioringr	(ea_ioringr),		 // Templated
			// Inputs
			.a		(ea_a),			 // Templated
			.ie		(ea_ie),		 // Templated
			.oe		(ea_oe),		 // Templated
			.pe		(ea_pe),		 // Templated
			.ps		(ea_ps),		 // Templated
			.sr		(ea_sr),		 // Templated
			.st		(ea_st),		 // Templated
			.ds		(ea_ds),		 // Templated
			.cfg		(ea_cfg));		 // Templated


	la_ioside isouth(/*AUTOINST*/
			 // Outputs
			 .z			(so_z),		 // Templated
			 // Inouts
			 .pad			(so_pad),	 // Templated
			 .vss			(no_vss),	 // Templated
			 .vdd			(so_vdd),	 // Templated
			 .vddio			(so_vddio),	 // Templated
			 .vssio			(so_vssio),	 // Templated
			 .ioring		(so_ioring),	 // Templated
			 .vddl			(so_vddl),	 // Templated
			 .vddiol		(so_vddiol),	 // Templated
			 .vssiol		(so_vssiol),	 // Templated
			 .ioringl		(so_ioringl),	 // Templated
			 .vddr			(so_vddr),	 // Templated
			 .vddior		(so_vddior),	 // Templated
			 .vssior		(so_vssior),	 // Templated
			 .ioringr		(so_ioringr),	 // Templated
			 // Inputs
			 .a			(so_a),		 // Templated
			 .ie			(so_ie),	 // Templated
			 .oe			(so_oe),	 // Templated
			 .pe			(so_pe),	 // Templated
			 .ps			(so_ps),	 // Templated
			 .sr			(so_sr),	 // Templated
			 .st			(so_st),	 // Templated
			 .ds			(so_ds),	 // Templated
			 .cfg			(so_cfg));	 // Templated


	la_ioside iwest(/*AUTOINST*/
			// Outputs
			.z		(we_z),			 // Templated
			// Inouts
			.pad		(we_pad),		 // Templated
			.vss		(no_vss),		 // Templated
			.vdd		(we_vdd),		 // Templated
			.vddio		(we_vddio),		 // Templated
			.vssio		(we_vssio),		 // Templated
			.ioring		(we_ioring),		 // Templated
			.vddl		(we_vddl),		 // Templated
			.vddiol		(we_vddiol),		 // Templated
			.vssiol		(we_vssiol),		 // Templated
			.ioringl	(we_ioringl),		 // Templated
			.vddr		(we_vddr),		 // Templated
			.vddior		(we_vddior),		 // Templated
			.vssior		(we_vssior),		 // Templated
			.ioringr	(we_ioringr),		 // Templated
			// Inputs
			.a		(we_a),			 // Templated
			.ie		(we_ie),		 // Templated
			.oe		(we_oe),		 // Templated
			.pe		(we_pe),		 // Templated
			.ps		(we_ps),		 // Templated
			.sr		(we_sr),		 // Templated
			.st		(we_st),		 // Templated
			.ds		(we_ds),		 // Templated
			.cfg		(we_cfg));		 // Templated

     end

endmodule // la_iopadring
