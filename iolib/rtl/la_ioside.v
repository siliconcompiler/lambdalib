/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Doc:
 *
 * Supports up to 31 individual sections per side (5 bits)
 *
 * Supports up to 255 pins per section/side (8 bits)
 *
 * Per section parameters are stuffed 8bit vectors:
 * {SECN, SECN-1, ...SEC1, SEC0}
 *
 * Example: If we have 4 sections (left to right) as seen from
 *   center with a total of 15 pins, with pins in section0=1, section1=2,
 *   section2=4, and section3=8, then we would enter the "N" parameter would
 *   be specified as "parameter N = {8'd12, 8'd, 8'd2, 8'd1}"
 *
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter [15:0]  SIDE       = "NO", // "NO", "SO", "EA", "WE"
    parameter [7:0]   NSIDE      = 1,    // total pins
    parameter [4:0]   SECTIONS   = 1,    // total number of sections
    parameter [0:0]   ENRCUT     = 1,    // enable cut cell on far right
    parameter [0:0]   ENLCUT     = 1,    // enable cut cell on far right
    parameter [0:0]   ENPOC      = 1,    // enable poc cells
    parameter [0:0]   ENCORNER   = 1,    // enable corner cell
    parameter [4:0]   CFGW       = 1,    // width of core config bus
    parameter [4:0]   RINGW      = 1,    // width of io ring
    // per section  parameters (stuffed vectors)
    parameter [255:0] NGPIO      = 1,    // digital pads
    parameter [255:0] NANALOG    = 0,    // analog pads
    parameter [255:0] NXTAL      = 0,    // xtal pads
    parameter [255:0] NVDDIO     = 1,    // total IO supply/ground pads
    parameter [255:0] NVDD       = 1,    // total core supply pads
    parameter [255:0] NGND       = 1,    // total ground pads
    parameter [255:0] NCLAMP     = 1,    // total esd clamp cells
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
    // supplies/ring
    inout [SECTIONS-1:0]       vdd, // core supply
    inout [SECTIONS-1:0]       vddio, // io supply
    inout [SECTIONS-1:0]       vssio, // io ground
    inout [SECTIONS*RINGW-1:0] ioring, // generic io-ring
    // left right braks/cuts
    inout 		       vddl, // core supply
    inout 		       vddiol, // io supply
    inout 		       vssiol, // io supply
    inout [RINGW-1:0] 	       ioringl, // generic io-ring
    inout 		       vddr, // core supply
    inout 		       vddior, // io supply
    inout 		       vssior, // io supply
    inout [RINGW-1:0] 	       ioringr // generic io-ring
    );

   genvar 	       i;
   genvar 	       j;

   // calculate offset to current section
   function [7:0] offset;
      input [7:0] i;
      input [255:0] vector;
      integer 	    ii;
      begin
	 offset = 0;
	 for(ii=0; ii<i; ii=ii+1)
	   offset = offset + vector[ii*8+:8];
      end
   endfunction

   //##########################################
   //# PLACE CORNER CELL
   //##########################################
   if (ENCORNER)
     begin: ila_iocorner
	la_iocorner #(.SIDE(SIDE),
		      .TYPE(IOTYPE),
		      .RINGW(RINGW))
	i0(.vdd     (vdd),
	   .vss     (vss),
	   .vddio   (vddio),
	   .vssio   (vssio),
	   .ioring  (ioring[RINGW-1:0]));
     end

   //##########################################
   //# PLACE SECTIONS
   //##########################################

   for(i=0;i<SECTIONS;i=i+1)
     begin: ila_iosection
	// figure out how many bits came before
	localparam [7:0] START = offset(i,NGPIO) +
				 offset(i,NANALOG) +
				 offset(i,NXTAL);

	localparam [7:0] N = NGPIO[8*i+:8] +
			     NANALOG[8*i+:8] +
			     NXTAL[8*i+:8];

	// Assign section
        la_iosection #(.SIDE(SIDE),
		       .N(N),
		       .NGPIO(NGPIO[8*i+:8]),
		       .NANALOG(NANALOG[8*i+:8]),
		       .NXTAL(NXTAL[8*i+:8]),
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
	    .z	   (z[START+:N]),
	    // Inouts
	    .vss	(vss),
	    .pad   (pad[START+:N]),
	    .vdd   (vdd[i]),
	    .vddio (vddio[i]),
	    .vssio (vssio[i]),
	    .ioring(ioring[i*RINGW+:RINGW]),
	    // Inputs
	    .a	   (a[START+:N]),
	    .ie	   (ie[START+:N]),
	    .oe    (oe[START+:N]),
	    .pe    (pe[START+:N]),
	    .ps    (ps[START+:N]),
	    .sr    (sr[START+:N]),
	    .st    (st[START+:N]),
	    .ds    (ds[START*3+:3*N]),
	    .cfg   (cfg[START*CFGW+:N*CFGW]));
     end // for (i=0;i<SECTIONS;i=i+1)

   //##########################################
   //# PLACE CUT CELLS
   //##########################################

   // place the last cut cell if enabled
   if (ENLCUT)
     begin: ila_iolcut
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
     begin: ila_iorcut
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
// verilog-library-directories:("." )
// End:
