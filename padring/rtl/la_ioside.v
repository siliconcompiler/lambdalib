/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Doc:
 *
 * See repo ./README.md
 *
 *
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter [15:0]   SIDE       = "NO", // "NO", "SO", "EA", "WE"
    parameter [7:0]    N          = 1,    // total pins per side (<256)
    parameter [7:0]    SECTIONS   = 1,    // total number of sections (<256)
    parameter [7:0]    CFGW       = 1,    // width of io config bus
    parameter [7:0]    RINGW      = 1,    // width of io ring
    parameter [0:0]    ENRCUT     = 1,    // enable cut cell on far right
    parameter [0:0]    ENLCUT     = 1,    // enable cut cell on far right
    parameter [0:0]    ENPOC      = 1,    // enable poc cells
    parameter [0:0]    ENCORNER   = 1,    // enable corner cell
    // per section  parameters (stuffed vectors of 8 bit values)
    // format is {SEC255, SEC254, ..., SEC1, SEC0}
    parameter [2047:0] NSPLIT     = 1,    // pins per section
    parameter [2047:0] NSTART     = 0,    // start position per section
    parameter [2047:0] NVDDIO     = 1,    // io supply cells per section
    parameter [2047:0] NVDD       = 1,    // core supply cells per section
    parameter [2047:0] NGND       = 1,    // ground cells per section
    parameter [2047:0] NCLAMP     = 1,    // esd clamp cells per section
    // options to overrride lib on per pin basis (8 bit values per pin)
    // format is {PIN255, PIN254, ..., PIN1, PIN0}
    parameter [2047:0] PINSELECT  = 0,
    parameter [2047:0] IOTYPE     = 0,
    parameter [2047:0] VDDIOTYPE  = 0,
    parameter [2047:0] VSSIOTYPE  = 0,
    parameter [2047:0] VDDTYPE    = 0,
    parameter [2047:0] VSSTYPE    = 0,
    parameter [2047:0] CLAMPTYPE  = 0,
    parameter [2047:0] CUTTYPE    = 0,
    parameter [2047:0] POCTYPE    = 0
    )
   (// io pad signals
    inout [N-1:0]      pad, // pad
    inout 	       vss, // common ground
    //core facing signals
    inout [N-1:0]      aio, // analog inout
    output [N-1:0]     z, // output to core
    input [N-1:0]      a, // input from core
    input [N-1:0]      ie, // input enable, 1 = active
    input [N-1:0]      oe, // output enable, 1 = active
    input [N*CFGW-1:0] cfg, // generic config interface
    // left right braks/cuts
    inout 	       vddr, // core supply
    inout 	       vddior, // io supply
    inout 	       vssior, // io supply
    inout [RINGW-1:0]  ioringr // generic io-ring
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
			  .N(NSPLIT[8*i+:8]),
			  .NVDDIO(NVDDIO[8*i+:8]),
			  .NVDD(NVDD[8*i+:8]),
			  .NGND(NGND[8*i+:8]),
			  .NCLAMP(NCLAMP[8*i+:8]),
			  .PINSELECT(PINSELECT),
			  .IOTYPE(IOTYPE),
			  .VDDTYPE(VDDTYPE),
			  .VSSTYPE(VSSTYPE),
			  .VDDIOTYPE(VDDIOTYPE),
			  .VSSIOTYPE(VSSIOTYPE),
			  .CLAMPTYPE(CLAMPTYPE),
			  .POCTYPE(POCTYPE),
			  .CFGW(CFGW),
			  .RINGW(RINGW),
			  .ENPOC(ENPOC))
	   i0 (// Outputs
	       .z     (z[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       // Inouts
	       .vss   (vss),
	       .pad   (pad[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       .vdd   (vdd[i]),
	       .vddio (vddio[i]),
	       .vssio (vssio[i]),
	       .ioring(ioring[i*RINGW+:RINGW]),
	       .aio   (aio[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       // Inputs
	       .a     (a[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       .ie    (ie[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       .oe    (oe[NSTART[i*8+:8]+:NSPLIT[i*8+:8]]),
	       .cfg   (cfg[CFGW*NSTART[i*8+:8]+:CFGW*NSPLIT[i*8+:8]]));

	end // for (i=0;i<SECTIONS;i=i+1)
   endgenerate

   //##########################################
   //# PLACE CUT CELLS
   //##########################################

   for(i=0;i<SECTIONS-1;i=i+1)
     begin: ila_iocut
	la_iocut #(.SIDE(SIDE),
		   .TYPE(CUTTYPE),
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
		   .TYPE(CUTTYPE),
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
		   .TYPE(CUTTYPE),
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
