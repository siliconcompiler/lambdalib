/*****************************************************************************
 * Function: IO padring side
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Doc:
 *
 * See repo ./README.md
 *
 * CELLTYPE:
 *
 * 0 = bidir
 * 1 = input
 * 2 = analog
 * 3 = xtal
 * 4 = RESERVED
 * 5 = RESERVED
 * 6 = RESERVED
 * 7 = RESERVED
 * 8 = vddio
 * 9 = vssio
 * 10 = vdd
 * 11 = vss
 * 12 = vdda
 * 13 = vssa
 * 14 = poc
 * 15 = cut
 * 16 = INTERAL
 * 17 = INTERNAL
 *
 ****************************************************************************/

module la_ioside
  #(// per side parameters
    parameter [15:0]   SIDE       = "NO", // "NO", "SO", "EA", "WE"
    parameter [7:0]    NPINS      = 4,    // total pins per side (<256)
    parameter [7:0]    NCELLS     = 8,    // total cells per side (<256)
    parameter [7:0]    NSECTIONS  = 8,    // total secti0ns per side (<256)
    parameter [2047:0] CELLTYPE   = 0,    // per cell type
    parameter [2047:0] PINMAP     = 0,    // cell to pin map
    parameter [2047:0] CUTMAP     = 0,    // cell to pin map
    parameter [7:0]    RINGW      = 1,    // width of io ring
    parameter [7:0]    CFGW       = 1     // config width
    )
   (// io pad signals
    inout [NPINS-1:0] 		pad, // pad
    //core facing signals
    inout [NPINS*3-1:0] 	aio, // analog inout
    output [NPINS-1:0] 		z, // output to core
    input [NPINS-1:0] 		a, // input from core
    input [NPINS-1:0] 		ie, // input enable, 1 = active
    input [NPINS-1:0] 		oe, // output enable, 1 = active
    input [NPINS*CFGW-1:0] 	cfg, // generic config interface
    // supplies/ring (per cell)
    inout 			vss, // common ground
    inout [NSECTIONS-1:0] 	vdd, // core supply
    inout [NSECTIONS-1:0] 	vddio, // io supply
    inout [NSECTIONS-1:0] 	vssio, // io ground
    inout [NSECTIONS*RINGW-1:0] ioring // generic io-ring
    );

   //##########################################
   //# PER CELL SELECTION
   //##########################################

   genvar  i,j;

   for(i=0;i<NCELLS;i=i+1)
     begin: ipadcell
	// BIDIR
	if (CELLTYPE[i*8+:4]==4'h0)
	  begin: ila_iobidir
	     la_iobidir #(.SIDE(SIDE),
			  .TYPE(CELLTYPE[(i*8+4)+:4]),
			  .CFGW(CFGW),
			  .RINGW(RINGW))
	     i0 (// pad
		 .pad	(pad[PINMAP[i*8+:8]]),
		 // core signalas
		 .z	(z[PINMAP[i*8+:8]]),
		 .a	(a[PINMAP[i*8+:8]]),
		 .ie	(ie[PINMAP[i*8+:8]]),
		 .oe	(oe[PINMAP[i*8+:8]]),
		 .cfg	(cfg[PINMAP[i*8+:8]*CFGW+:CFGW]),
		 // supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// INPUT
	else if (CELLTYPE[i*8+:4]==4'h1)
	  begin: ila_ioinput
	     la_ioinput #(.SIDE(SIDE),
			  .TYPE(CELLTYPE[(i*8+4)+:4]),
			  .CFGW(CFGW),
			  .RINGW(RINGW))
	     i0 (// pad
		 .pad	(pad[PINMAP[i*8+:8]]),
		 // core signalas
		 .z	(z[PINMAP[i*8+:8]]),
		 .ie	(ie[PINMAP[i*8+:8]]),
		 .cfg	(cfg[PINMAP[i*8+:8]*CFGW+:CFGW]),
		 // supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// ANALOG
	else if (CELLTYPE[i*8+:4]==4'h2)
	  begin: ila_ioanalog
	     la_ioanalog #(.SIDE(SIDE),
			   .TYPE(CELLTYPE[(i*8+4)+:4]),
			   .RINGW(RINGW))
	     i0 (// pad
		 .pad	(pad[PINMAP[i*8+:8]]),
		 // core signalas
		 .aio	(aio[i*3+:3]),
		 // supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// XTAL
	else if (CELLTYPE[i*8+:4]==4'h3)
	    begin: ila_ioxtal
	     la_ioxtal #(.SIDE(SIDE),
			 .TYPE(CELLTYPE[(i*8+4)+:4]),
			 .RINGW(RINGW))
	     i0 (// pad
		 .padi  (pad[PINMAP[i*8+:8]]),
		 .pado  (pad[i+1]), //TODO: fix!
		 // supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	    end
	// POC
	else if (CELLTYPE[i*8+:4]==4'h4)
	  begin: ila_iopoc
	     la_iopoc #(.SIDE(SIDE),
			.TYPE(CELLTYPE[(i*8+4)+:4]),
			.RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// CUT
	else if (CELLTYPE[i*8+:4]==4'h5)
	  begin: ila_iocut
	     la_iocut #(.SIDE(SIDE),
			.TYPE(CELLTYPE[(i*8+4)+:4]),
			.RINGW(RINGW))
	     i0();
	  end
	// CLAMP
	else if (CELLTYPE[i*8+:4]==4'h6)
	  begin: ila_ioclamp
	     // TODO
	  end
	// VDDIO
	else if (CELLTYPE[i*8+:4]==4'h8)
	  begin: ila_iovddio
	     la_iovddio #(.SIDE(SIDE),
			  .TYPE(CELLTYPE[(i*8+4)+:4]),
			  .RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// VSSIO
	else if (CELLTYPE[i*8+:4]==4'h9)
	  begin: ila_iovssio
	     la_iovssio #(.SIDE(SIDE),
			  .TYPE(CELLTYPE[(i*8+4)+:4]),
			  .RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// VDD
	else if (CELLTYPE[i*8+:4]==4'hA)
	  begin: ila_iovdd
	     la_iovdd #(.SIDE(SIDE),
			.TYPE(CELLTYPE[(i*8+4)+:4]),
			.RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// VSS
	else if (CELLTYPE[i*8+:4]==4'hB)
	  begin: ila_iovss
	     la_iovss #(.SIDE(SIDE),
			.TYPE(CELLTYPE[(i*8+4)+:4]),
			.RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// VDDA
	else if (CELLTYPE[i*8+:4]==4'hC)
	  begin: ila_iovdda
	     la_iovdda #(.SIDE(SIDE),
			 .TYPE(CELLTYPE[(i*8+4)+:4]),
			 .RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end
	// VSSA
	else if (CELLTYPE[i*8+:4]==4'hD)
	  begin: ila_iovssa
	     la_iovssa #(.SIDE(SIDE),
			 .TYPE(CELLTYPE[(i*8+4)+:4]),
			 .RINGW(RINGW))
	     i0 (// supplies
		 .vss	(vss),
		 .vdd	(vdd[CUTMAP[i*8+:8]]),
		 .vddio (vddio[CUTMAP[i*8+:8]]),
		 .vssio	(vssio[CUTMAP[i*8+:8]]),
		 // ring
		 .ioring(ioring[CUTMAP[i*8+:8]*RINGW+:RINGW]));
	  end // block: ila_iovssa
     end

endmodule
// Local Variables:
// verilog-library-directories:("." "../stub")
// End:
