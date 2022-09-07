/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Doc:
 *
 * Supports up to 31 individual sections per side (5 bits)
 *
 * Supports up to 63 pins per section/side (8 bits)
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
    parameter [7:0]   NSIDE      = 1,    // total pins per side
    parameter [4:0]   SECTIONS   = 1,    // total number of sections
    parameter [4:0]   CFGW       = 1,    // width of core config bus
    parameter [4:0]   RINGW      = 1,    // width of io ring
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
	   .vss     (vssl),
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
