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
    parameter [7:0]  CFGW   = 16,        // width of core config bus
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
    parameter [7:0]  NO_SECTIONS =  1,
    parameter [7:0]  NO_NSIDE    =  8'h8,
    parameter [63:0] NO_N        =  64'h0404,
    parameter [63:0] NO_NSEL     =  64'h0,
    parameter [63:0] NO_NSTART   =  64'h00,
    parameter [63:0] NO_NVDDIO   =  64'h01,
    parameter [63:0] NO_NVDD     =  64'h01,
    parameter [63:0] NO_NGND     =  64'h01,
    parameter [63:0] NO_NCLAMP   =  64'h00,
    parameter [7:0]  EA_SECTIONS =  1,
    parameter [7:0]  EA_NSIDE    =  8'h8,
    parameter [63:0] EA_N        =  64'h08,
    parameter [63:0] EA_NSEL     =  64'h0,
    parameter [63:0] EA_NSTART   =  64'h00,
    parameter [63:0] EA_NVDDIO   =  64'h01,
    parameter [63:0] EA_NVDD     =  64'h01,
    parameter [63:0] EA_NGND     =  64'h01,
    parameter [63:0] EA_NCLAMP   =  64'h00,
    parameter [7:0]  SO_SECTIONS =  1,
    parameter [7:0]  SO_NSIDE    =  8'h8,
    parameter [63:0] SO_N        =  64'h08,
    parameter [63:0] SO_NSEL     =  64'h0,
    parameter [63:0] SO_NSTART   =  64'h00,
    parameter [63:0] SO_NVDDIO   =  64'h01,
    parameter [63:0] SO_NVDD     =  64'h01,
    parameter [63:0] SO_NGND     =  64'h01,
    parameter [63:0] SO_NCLAMP   =  64'h00,
    parameter [7:0]  WE_SECTIONS =  1,
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

/*****************************************************************************
 * Function: IO padring section
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 *
 * Doc:
 *
 * - The order of pads is digital-->analog-->xtal in a clock wise fashion
 *
 *
 ****************************************************************************/

module la_iosection
  #(parameter [15:0] SIDE      = "NO",  // "NO", "SO", "EA", "WE"
    parameter [7:0]  N         = 0,     // total pads
    parameter [63:0] NSEL      = 0,     // 0=gpio, 1=analog, 2=xtal,..
    parameter [7:0]  NVDDIO    = 0,     // IO supply pads
    parameter [7:0]  NVDD      = 0,     // core supply pads
    parameter [7:0]  NGND      = 0,     // core ground pads
    parameter [7:0]  NCLAMP    = 0,     // clamp cells
    parameter [4:0]  CFGW      = 8,     // width of core config bus
    parameter [4:0]  RINGW     = 8,     // width of io ring
    parameter [0:0]  ENPOC     = 1,     // 1=place poc cell
    // These are generally hard coded in library
    parameter IOTYPE     = "DEFAULT", // io cell type
    parameter XTALTYPE   = "DEFAULT", // io cell type
    parameter ANALOGTYPE = "DEFAULT", // io cell type
    parameter POCTYPE    = "DEFAULT", // poc cell type
    parameter VDDTYPE    = "DEFAULT", // vdd cell type
    parameter VDDIOTYPE  = "DEFAULT", // vddio cell type
    parameter VSSIOTYPE  = "DEFAULT", // vssio cell type
    parameter VSSTYPE    = "DEFAULT"  // vss cell type
    )
   (// io pad signals
    inout [N-1:0]      pad, // pad
    inout 	       vss, // common ground
    // io signals
    inout 	       vdd, // core supply
    inout 	       vddio, // io supply
    inout 	       vssio, // io ground
    inout [RINGW-1:0]  ioring, // generic io-ring
    //core facing signals
    input [N-1:0]      a, // input from core
    output [N-1:0]     z, // output to core
    input [N-1:0]      ie, // input enable, 1 = active
    input [N-1:0]      oe, // output enable, 1 = active
    input [N-1:0]      pe, // pullup enable, 1 = active
    input [N-1:0]      ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [N-1:0]      sr, // slewrate enable 1 = slow, 1 = fast
    input [N-1:0]      st, // schmitt trigger, 1 = enable
    input [N*3-1:0]    ds, // drive strength, 3'b0 = weakest
    input [N*CFGW-1:0] cfg // generic config interface
    );


   genvar 	       i;

   //##########################################
   //# BIDIR GPIO BUFFERS
   //##########################################
   for(i=0;i<N;i=i+1)
     begin: ipad
	if (NSEL[i*8+:8]==8'h0)
	  begin: ila_iobidir
	     la_iobidir #(.SIDE(SIDE),
			  .TYPE(IOTYPE),
			  .CFGW(CFGW),
			  .RINGW(RINGW))
	     i0 (// Outputs
		 .z	(z[i]),
		 // Inouts
		 .pad	(pad[i]),
		 .vdd	(vdd),
		 .vss	(vss),
		 .vddio (vddio),
		 .vssio	(vssio),
		 .ioring(ioring[RINGW-1:0]),
		 // Inputs
		 .a	(a[i]),
		 .ie	(ie[i]),
		 .oe	(oe[i]),
		 .pe	(pe[i]),
		 .ps	(ps[i]),
		 .sr	(sr[i]),
		 .st	(st[i]),
		 .ds	(ds[i*3+:3]),
		 .cfg	(cfg[i*CFGW+:CFGW]));
	  end // block: ila_iobidir
	else if (NSEL[i*8+:8]==8'h1)
	  begin: ila_ioanalog
	     la_ioanalog #(.SIDE(SIDE),
			   .TYPE(IOTYPE),
			   .RINGW(RINGW))
	     i0 (.pad    (pad[i]),
		 .vdd    (vdd),
		 .vss    (vss),
		 .vddio  (vddio),
		 .vssio  (vssio),
		 .a      (a[i]),
		 .z      (z[i]),
		 .ioring (ioring[RINGW-1:0]));
	  end // block: ila_ioanalog
	else if (NSEL[i*8+:8]==8'h2)
	  begin
	     la_ioxtal #(.SIDE(SIDE),
			 .TYPE(IOTYPE),
			 .RINGW(RINGW))
	     i0 (.pad    (pad[i]),
		 .vdd    (vdd),
		 .vss    (vss),
		 .vddio  (vddio),
		 .vssio  (vssio),
		 .a      (a[i]),
		 .z      (z[i]),
		 .ioring (ioring[RINGW-1:0]));
	  end
     end

   //##########################################
   //# VDDIO/VSSIO
   //##########################################

   for(i=0;i<NVDDIO;i=i+1)
     begin: ila_iovddio
	// vddio
	la_iovddio #(.SIDE(SIDE),
		     .TYPE(VDDIOTYPE),
		     .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end // block: la_iovddio

   for(i=0;i<NVDDIO;i=i+1)
     begin: ila_iovssio
	la_iovssio #(.SIDE(SIDE),
		     .TYPE(VSSIOTYPE),
		     .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end

   //##########################################
   //# VDD
   //##########################################

   for(i=0;i<NVDD;i=i+1)
     begin: ila_iovdd
	la_iovdd #(.SIDE(SIDE),
		   .TYPE(VDDTYPE),
		   .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end

   //##########################################
   //# VSS
   //##########################################

   for(i=0;i<NGND;i=i+1)
     begin: ila_iovss
	la_iovss #(.SIDE(SIDE),
		   .TYPE(VSSTYPE),
		   .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end

   //##########################################
   //# ESD CLAMP
   //##########################################

   for(i=0;i<NCLAMP;i=i+1)
     begin: ila_ioclamp
	la_ioclamp #(.SIDE(SIDE),
		     .TYPE(VSSTYPE),
		     .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end

   //#########################################
   //# POWER ON CONTROL
   //#########################################

   if (ENPOC)
     begin: ila_iopoc
	la_iopoc #(.SIDE(SIDE),
		   .TYPE(POCTYPE),
		   .RINGW(RINGW))
	i0 (.vdd     (vdd),
	    .vss     (vss),
	    .vddio   (vddio),
	    .vssio   (vssio),
	    .ioring  (ioring[RINGW-1:0]));
     end // if (ENCUT)

endmodule
// Local Variables:
// verilog-library-directories:("." "../stub")
// End:

/*****************************************************************************
 * Function: IO corner cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iocorner
  #(parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule

/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Doc:
 *
 * (see la_iopadring.v)
 *
 *
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter [15:0]  SIDE       = "NO", // "NO", "SO", "EA", "WE"
    parameter [7:0]   SECTIONS   = 1,    // total number of sections (16)
    parameter [7:0]   NSIDE      = 1,    // total pins per side (256)
    parameter [7:0]   CFGW       = 1,    // width of core config bus
    parameter [7:0]   RINGW      = 1,    // width of io ring
    parameter [0:0]   ENRCUT     = 1,    // enable cut cell on far right
    parameter [0:0]   ENLCUT     = 1,    // enable cut cell on far right
    parameter [0:0]   ENPOC      = 1,    // enable poc cells
    parameter [0:0]   ENCORNER   = 1,    // enable corner cell
    // per section  parameters (stuffed vectors)
    // format is {SECN, SECN-1, ...SEC1, SEC0}
    parameter [63:0]  N          = 1,    // number of pins
    parameter [63:0]  NSTART     = 0,    // start position
    parameter [63:0]  NSEL       = 0,    // 0=gpio, 1=analog, 2=xtal,..
    parameter [63:0]  NVDDIO     = 1,    // IO supply/ground pads
    parameter [63:0]  NVDD       = 1,    // core supply pads
    parameter [63:0]  NGND       = 1,    // ground pads
    parameter [63:0]  NCLAMP     = 1,    // esd clamp cells
    // options to overrride lalib
    parameter IOTYPE     = "DEFAULT",    // io cell type
    parameter XTALTYPE   = "DEFAULT",    // io cell type
    parameter ANALOGTYPE = "DEFAULT",    // io cell type
    parameter POCTYPE    = "DEFAULT",    // poc cell type
    parameter VDDTYPE    = "DEFAULT",    // vdd cell type
    parameter VDDIOTYPE  = "DEFAULT",    // vddio cell type
    parameter VSSIOTYPE  = "DEFAULT",    // vssio cell type
    parameter VSSTYPE    = "DEFAULT"     // vss cell type
    )
   (// io pad signals
    inout [NSIDE-1:0] 	       pad, // pad
    inout 		       vss, // common ground
    //core facing signals
    output [NSIDE-1:0] 	       z, // output to core
    input [NSIDE-1:0] 	       a, // input from core
    input [NSIDE-1:0] 	       ie, // input enable, 1 = active
    input [NSIDE-1:0] 	       oe, // output enable, 1 = active
    input [NSIDE-1:0] 	       pe, // pullup enable, 1 = active
    input [NSIDE-1:0] 	       ps, // pullup select, 1 = pull-up, 0 = pull-down
    input [NSIDE-1:0] 	       sr, // slewrate enable 1 = slow, 1 = fast
    input [NSIDE-1:0] 	       st, // schmitt trigger, 1 = enable
    input [NSIDE*3-1:0]        ds, // drive strength, 3'b0 = weakest
    input [NSIDE*CFGW-1:0]     cfg, // generic config interface
    // left right braks/cuts
    inout 		       vddr, // core supply
    inout 		       vddior, // io supply
    inout 		       vssior, // io supply
    inout [RINGW-1:0] 	       ioringr // generic io-ring
    );

   genvar 	       j;

   //##########################################
   //# LOCAL WIRES
   //##########################################

   wire 	              vddl;
   wire 	              vddiol;
   wire 	              vssiol;
   wire [RINGW-1:0]           ioringl;

   wire [SECTIONS-1:0]        vdd;
   wire [SECTIONS-1:0]        vddio;
   wire [SECTIONS-1:0]        vssio;
   wire [SECTIONS*RINGW-1:0]  ioring;

   //##########################################
   //# PLACE CORNER CELL
   //##########################################

   if (ENCORNER)
     begin: ila_iocorner
	la_iocorner #(.SIDE(SIDE),
		      .TYPE(IOTYPE),
		      .RINGW(RINGW))
	i0(.vdd     (vddl),
	   .vss     (vss),
	   .vddio   (vddiol),
	   .vssio   (vssiol),
	   .ioring  (ioringl[RINGW-1:0]));
     end

   //##########################################
   //# PLACE SECTIONS
   //##########################################
   genvar i;
   generate
      for(i=0;i<SECTIONS;i=i+1)
	begin: ila_iosection
	   // Assign section
           la_iosection #(.SIDE(SIDE),
			  .N(N[8*i+:8]),
			  .NSEL(NSEL[8*i+:8]),
			  .NVDDIO(NVDDIO[8*i+:8]),
			  .NVDD(NVDD[8*i+:8]),
			  .NGND(NGND[8*i+:8]),
			  .NCLAMP(NCLAMP[8*i+:8]),
			  .CFGW(CFGW),
			  .RINGW(RINGW),
			  .ENPOC(ENPOC),
			  .IOTYPE(IOTYPE),
			  .ANALOGTYPE(ANALOGTYPE),
			  .XTALTYPE(XTALTYPE),
			  .POCTYPE(POCTYPE),
			  .VDDTYPE(VDDTYPE),
			  .VDDIOTYPE(VDDIOTYPE),
			  .VSSIOTYPE(VSSIOTYPE),
			  .VSSTYPE(VSSTYPE))
	   i0 (// Outputs
	       .z	   (z[NSTART[i*8+:8]+:N[i*8+:8]]),
	       // Inouts
	       .vss   (vss),
	       .pad   (pad[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .vdd   (vdd[i]),
	       .vddio (vddio[i]),
	       .vssio (vssio[i]),
	       .ioring(ioring[i*RINGW+:RINGW]),
	       // Inputs
	       .a     (a[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .ie    (ie[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .oe    (oe[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .pe    (pe[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .ps    (ps[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .sr    (sr[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .st    (st[NSTART[i*8+:8]+:N[i*8+:8]]),
	       .ds    (ds[3*NSTART[i*8+:8]+:3*N[i*8+:8]]),
	       .cfg   (cfg[CFGW*NSTART[i*8+:8]+:CFGW*N[i*8+:8]]));

	end // for (i=0;i<SECTIONS;i=i+1)
   endgenerate

   //##########################################
   //# PLACE CUT CELLS
   //##########################################

   for(i=0;i<SECTIONS-1;i=i+1)
     begin: ila_iocut
	la_iocut #(.SIDE(SIDE),
		   .TYPE(IOTYPE),
		   .RINGW(RINGW))
	i0(.vss     (vss),
	   .vddl    (vdd[i]),
	   .vddiol  (vddio[i]),
	   .vssiol  (vssio[i]),
	   .ioringl (ioring[i*RINGW+:RINGW]),
	   .vddr    (vdd[i+1]),
	   .vddior  (vddio[i+1]),
	   .vssior  (vssio[i+1]),
	   .ioringr (ioring[(i+1)*RINGW+:RINGW]));
     end

   // place the last cut cell if enabled
   if (ENLCUT)
     begin: ila_ioleftcut
	la_iocut #(.SIDE(SIDE),
		   .TYPE(IOTYPE),
		   .RINGW(RINGW))
	i0(.vss	    (vss),
	   .vddl    (vddl),
	   .vddiol  (vddiol),
	   .vssiol  (vssiol),
	   .ioringl (ioringl[RINGW-1:0]),
	   .vddr    (vdd[0]),
	   .vddior  (vddio[0]),
	   .vssior  (vssio[0]),
	   .ioringr (ioring[RINGW-1:0]));
     end // if (ENLCUT)

   // place the last cut cell if enabled
   if (ENRCUT)
     begin: ila_iorightcut
	la_iocut #(.SIDE(SIDE),
		   .TYPE(IOTYPE),
		   .RINGW(RINGW))
	i0(.vss     (vss),
	   .vddl    (vdd[SECTIONS-1]),
	   .vddiol  (vddio[SECTIONS-1]),
	   .vssiol  (vssio[SECTIONS-1]),
	   .ioringl (ioring[(SECTIONS-1)*RINGW+:RINGW]),
	   .vddr    (vddr),
	   .vddior  (vddior),
	   .vssior  (vssior),
	   .ioringr (ioringr[RINGW-1:0]));
     end // if (ENRCUT)



endmodule
// Local Variables:
// verilog-library-directories:("." "../stub")
// End:

/*****************************************************************************
 * Function: IO power-on-control cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iopoc
  #(parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule

/*****************************************************************************
 * Function: IO supply cell (vdd)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovdd
  #(parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule // la_iovdd

/*****************************************************************************
 * Function: IO supply cell (vddio)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovddio
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule

/*****************************************************************************
 * Function: IO supply cell (vssio)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovssio
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule

/*****************************************************************************
 * Function: IO bi-directional buffer
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a generic cell that defines the standard interface of the lambda
 * bidrectional buffer cell. It is only suitable for FPGA synthesis.
 *
 * ASIC specific libraries will need to use the TYPE field to select an
 * appropriate hardcoded physical cell based on the the process constraints
 * and library composition. For example, modern nodes will usually have
 * different IP cells for the placing cells vvertically or horizontally.
 *
 ****************************************************************************/
module la_iobidir
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter CFGW  =  16,       // width of core config bus
    parameter RINGW =  8 // width of io ring
    )
   (// io pad signals
    inout 	      pad, // bidirectional pad signal
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    // core facing signals
    input 	      a, // input from core
    output 	      z, // output to core
    input 	      ie, // input enable, 1 = active
    input 	      oe, // output enable, 1 = active
    input 	      pe, // weak pull enable, 1 = active
    input 	      ps,// pull select, 1 = pull-up, 0 = pull-down
    input 	      sr, // slewrate enable 1 = fast, 0 = slow
    input 	      st, // schmitt trigger, 1 = enable
    input [2:0]       ds, // drive strength, 3'b0 = weakest
    inout [RINGW-1:0] ioring, // generic io-ring interface
    input [CFGW-1:0]  cfg // generic config interface
    );

   // to core
   assign z   = ie ? pad : 1'b0;

   // to pad (verilator only)
   assign pad = oe         ? a    :
		(pe & ps)  ? 1'b1 :
		(pe & !ps) ? 1'b0 :
                             1'bz;

endmodule

/*****************************************************************************
 * Function: IO cut cell
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iocut
  #(
    parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    // ground never cut
    inout 	      vss,
    // left side (viewed from center)
    inout 	      vddl, // core
    inout 	      vddiol, // io supply
    inout 	      vssiol, // left io ground
    inout [RINGW-1:0] ioringl, // left ioring
    // right side (viewed from center)
    inout 	      vddr, // core (from center)
    inout 	      vddior, // io supply
    inout 	      vssior, // left io ground
    inout [RINGW-1:0] ioringr // left ioring
    );

endmodule

/*****************************************************************************
 * Function: IO supply cell (vss)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 *
 ****************************************************************************/
module la_iovss
  #(parameter TYPE  = "DEFAULT", // cell type
    parameter SIDE  = "NO",      // "NO", "SO", "EA", "WE"
    parameter RINGW =  8 // width of io ring
    )
   (
    inout 	      vdd, // core supply
    inout 	      vss, // core ground
    inout 	      vddio, // io supply
    inout 	      vssio, // io ground
    inout [RINGW-1:0] ioring // generic io-ring interface
    );

endmodule

