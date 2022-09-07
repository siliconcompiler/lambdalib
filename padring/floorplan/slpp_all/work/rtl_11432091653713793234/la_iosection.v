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
    parameter [7:0]  N         = 8,     // total pads
    parameter [63:0] NSEL      = 0,     // 0=gpio, 1=analog, 2=xtal,..
    parameter [7:0]  NVDDIO    = 1,     // IO supply pads
    parameter [7:0]  NVDD      = 1,     // core supply pads
    parameter [7:0]  NGND      = 1,     // core ground pads
    parameter [7:0]  NCLAMP    = 1,     // clamp cells
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
