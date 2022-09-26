/*****************************************************************************
 * Function: IO padring section
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 *
 * Doc:
 *
 * 1. PINSELECT selection:
 *    0 = bidir
 *    1 = input only
 *    2 = analog signal
 *    3 = xtal
 *
 ****************************************************************************/

module la_iosection
  #(parameter [15:0]   SIDE    = "NO",  // "NO", "SO", "EA", "WE"
    parameter [4:0]    CFGW    = 8,     // width of core config bus
    parameter [4:0]    RINGW   = 8,     // width of io ring
    parameter [0:0]    ENPOC   = 1,     // 1=place poc cell
    // global settings for section
    parameter [7:0]    N       = 1,     // total cells in section
    parameter [7:0]    NSTART  = 0,     // start position for section
    parameter [7:0]    NVDDIO  = 0,     // IO supply cells
    parameter [7:0]    NVDD    = 0,     // core supply cells
    parameter [7:0]    NGND    = 0,     // ground cells
    parameter [7:0]    NCLAMP  = 0,     // clamp cells
    // options to overrride lib on per pin basis (8 bit values per pin)
    // format is {PIN255, PIN254, ..., PIN1, PIN0}
    parameter [2047:0] PINSELECT  = 0,
    parameter [2047:0] IOTYPE     = 0,
    parameter [2047:0] VDDIOTYPE  = 0,
    parameter [2047:0] VSSIOTYPE  = 0,
    parameter [2047:0] VDDTYPE    = 0,
    parameter [2047:0] VSSTYPE    = 0,
    parameter [2047:0] CLAMPTYPE  = 0,
    parameter [2047:0] POCTYPE    = 0
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
    inout [N-1:0]      aio, // analog inout
    input [N-1:0]      a, // value to pad
    output [N-1:0]     z, // value from pad
    input [N-1:0]      ie, // input enable, 1 = active
    input [N-1:0]      oe, // output enable, 1 = active
    input [N*CFGW-1:0] cfg // generic config interface
    );

   genvar 	       i;

   //##########################################
   //# BIDIR GPIO BUFFERS
   //##########################################
   for(i=0;i<N;i=i+1)
     begin: ipad
	if (PINSELECT[NSTART+i*8+:8]==8'h0)
	  begin: ila_iobidir
	     la_iobidir #(.SIDE(SIDE),
			  .TYPE(IOTYPE[NSTART+8*i+:8]),
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
		 .cfg	(cfg[i*CFGW+:CFGW]));
	  end // block: ila_iobidir
	else if (PINSELECT[NSTART+i*8+:8]==8'h1)
	  begin: ila_ioinput
	     la_ioinput #(.SIDE(SIDE),
			  .TYPE(IOTYPE[NSTART+8*i+:8]),
			  .RINGW(RINGW))
	     i0 (.pad    (pad[i]),
		 .vdd    (vdd),
		 .vss    (vss),
		 .vddio  (vddio),
		 .vssio  (vssio),
		 .ie	 (ie[i]),
		 .z      (z[i]),
		 .ioring (ioring[RINGW-1:0]));
	  end // block: ila_ioanalog

	else if (PINSELECT[NSTART+i*8+:8]==8'h2)
	  begin: ila_ioanalog
	     la_ioanalog #(.SIDE(SIDE),
			   .TYPE(IOTYPE[NSTART+8*i+:8]),
			   .RINGW(RINGW))
	     i0 (.pad    (pad[i]),
		 .vdd    (vdd),
		 .vss    (vss),
		 .vddio  (vddio),
		 .vssio  (vssio),
		 .aio    (aio[i]),
		 .ioring (ioring[RINGW-1:0]));
	  end // block: ila_ioanalog
	else if (PINSELECT[NSTART+i*8+:8]==8'h3)
	  begin
	     la_ioxtal #(.SIDE(SIDE),
			 .TYPE(IOTYPE[NSTART+8*i+:8]),
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
		     .TYPE(VDDIOTYPE[NSTART+8*i+:8]),
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
		     .TYPE(VSSIOTYPE[NSTART+8*i+:8]),
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
		   .TYPE(VDDTYPE[NSTART+8*i+:8]),
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
		   .TYPE(VSSTYPE[NSTART+8*i+:8]),
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
		     .TYPE(CLAMPTYPE[NSTART+8*i+:8]),
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
		   .TYPE(POCTYPE[NSTART+:8]),
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
