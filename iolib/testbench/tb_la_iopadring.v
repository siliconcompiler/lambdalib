module testbench();

   parameter [7:0] CFGW  = 8'h8;
   parameter [7:0] RINGW = 8'h8;
   parameter [0:0] ENCUT = 1'h1;
   parameter [0:0] ENPOC = 1'h1;

   parameter [4:0]  NO_SECTIONS =  2; // north
   parameter [7:0]  NO_NSIDE    =  8'h8;
   parameter [63:0] NO_NGPIO    =  64'h8040201008040201;
   parameter [63:0] NO_NANALOG  =  64'h0000000001000201;
   parameter [63:0] NO_NXTAL    =  64'h0000000001020001;
   parameter [63:0] NO_NVDDIO   =  64'h0807060504030201;
   parameter [63:0] NO_NVDD     =  64'h0807060504030201;
   parameter [63:0] NO_NGND     =  64'h0807060504030201;
   parameter [63:0] NO_NCLAMP   =  64'h0807060504030201;
   parameter [4:0]  EA_SECTIONS =  2; // north
   parameter [7:0]  EA_NSIDE    =  8'h10;
   parameter [63:0] EA_NGPIO    =  64'h8040201008040201;
   parameter [63:0] EA_NANALOG  =  64'h0000000001000201;
   parameter [63:0] EA_NXTAL    =  64'h0000000001020001;
   parameter [63:0] EA_NVDDIO   =  64'h0807060504030201;
   parameter [63:0] EA_NVDD     =  64'h0807060504030201;
   parameter [63:0] EA_NGND     =  64'h0807060504030201;
   parameter [63:0] EA_NCLAMP   =  64'h0807060504030201;
   parameter [4:0]  SO_SECTIONS =  2; // north
   parameter [7:0]  SO_NSIDE    =  8'h20;
   parameter [63:0] SO_NGPIO    =  64'h8040201008040201;
   parameter [63:0] SO_NANALOG  =  64'h0000000001000201;
   parameter [63:0] SO_NXTAL    =  64'h0000000001020001;
   parameter [63:0] SO_NVDDIO   =  64'h0807060504030201;
   parameter [63:0] SO_NVDD     =  64'h0807060504030201;
   parameter [63:0] SO_NGND     =  64'h0807060504030201;
   parameter [63:0] SO_NCLAMP   =  64'h0807060504030201;
   parameter [4:0]  WE_SECTIONS =  2; // north
   parameter [7:0]  WE_NSIDE    =  8'h40;
   parameter [63:0] WE_NGPIO    =  64'h8040201008040201;
   parameter [63:0] WE_NANALOG  =  64'h0000000001000201;
   parameter [63:0] WE_NXTAL    =  64'h0000000001020001;
   parameter [63:0] WE_NVDDIO   =  64'h0807060504030201;
   parameter [63:0] WE_NVDD     =  64'h0807060504030201;
   parameter [63:0] WE_NGND     =  64'h0807060504030201;
   parameter [63:0] WE_NCLAMP   =  64'h0807060504030201;

   // local wires
   wire [EA_NSIDE-1:0] ea_z;			// From dut of la_iopadring.v
   wire [NO_NSIDE-1:0] no_z;			// From dut of la_iopadring.v
   wire [SO_NSIDE-1:0] so_z;			// From dut of la_iopadring.v
   wire [WE_NSIDE-1:0] we_z;			// From dut of la_iopadring.v
   wire 	       vss;			// To/From dut of la_iopadring.v
   wire 	       dut_fail;		// To oh_simctrl of oh_simctrl.v
   wire 	       dut_done;

   // local params (needed to avoid overflow in concat)
   localparam [15:0] NO_CFGW = NO_NSIDE * CFGW;
   localparam [15:0] EA_CFGW = EA_NSIDE * CFGW;
   localparam [15:0] SO_CFGW = SO_NSIDE * CFGW;
   localparam [15:0] WE_CFGW = WE_NSIDE * CFGW;

   /*AUTOINPUT*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			clk;			// From oh_simctrl of oh_simctrl.v
   wire [EA_NSIDE-1:0]	ea_pad;			// To/From dut of la_iopadring.v
   wire [EA_SECTIONS-1:0] ea_vdd;		// To/From dut of la_iopadring.v
   wire [EA_SECTIONS-1:0] ea_vddio;		// To/From dut of la_iopadring.v
   wire [EA_SECTIONS-1:0] ea_vssdio;		// To/From dut of la_iopadring.v
   wire			fastclk;		// From oh_simctrl of oh_simctrl.v
   wire [2:0]		mode;			// From oh_simctrl of oh_simctrl.v
   wire [NO_NSIDE-1:0]	no_pad;			// To/From dut of la_iopadring.v
   wire [NO_SECTIONS-1:0] no_vdd;		// To/From dut of la_iopadring.v
   wire [NO_SECTIONS-1:0] no_vddio;		// To/From dut of la_iopadring.v
   wire [NO_SECTIONS-1:0] no_vssdio;		// To/From dut of la_iopadring.v
   wire			nreset;			// From oh_simctrl of oh_simctrl.v
   wire			slowclk;		// From oh_simctrl of oh_simctrl.v
   wire [SO_NSIDE-1:0]	so_pad;			// To/From dut of la_iopadring.v
   wire [SO_SECTIONS-1:0] so_vdd;		// To/From dut of la_iopadring.v
   wire [SO_SECTIONS-1:0] so_vddio;		// To/From dut of la_iopadring.v
   wire [SO_SECTIONS-1:0] so_vssdio;		// To/From dut of la_iopadring.v
   wire [WE_NSIDE-1:0]	we_pad;			// To/From dut of la_iopadring.v
   wire [WE_SECTIONS-1:0] we_vdd;		// To/From dut of la_iopadring.v
   wire [WE_SECTIONS-1:0] we_vddio;		// To/From dut of la_iopadring.v
   wire [WE_SECTIONS-1:0] we_vssdio;		// To/From dut of la_iopadring.v
   // End of automatics

   //#################################
   // SIMULATION
   //#################################

   oh_simctrl oh_simctrl (/*AUTOINST*/
			  // Outputs
			  .nreset		(nreset),
			  .clk			(clk),
			  .fastclk		(fastclk),
			  .slowclk		(slowclk),
			  .mode			(mode[2:0]),
			  // Inputs
			  .dut_fail		(dut_fail),
			  .dut_done		(dut_done));


   //#################################
   // DUT
   //#################################

   /*la_iopadring AUTO_TEMPLATE (//outputs
    .\(.*\)_z    (\1_z[]),
    .\(.*\)_pad	 (\1_pad[]),
    .\(.*\)_vdd	 (\1_vdd[]),
    .\(.*\)_vddio(\1_vddio[]),
    .\(.*\)_vssio(\1_vssdio[]),
    .no_\(.*\)	 ({NO_NSIDE{1'b0}}),
    .no_cfg	 ({NO_CFGW{1'b0}}),
    .no_ds	 ({3*NO_NSIDE{1'b0}}),
    .ea_\(.*\)	 ({EA_NSIDE{1'b0}}),
    .ea_cfg	 ({EA_CFGW{1'b0}}),
    .ea_ds	 ({3*EA_NSIDE{1'b0}}),
    .so_\(.*\)	 ({SO_NSIDE{1'b0}}),
    .so_cfg	 ({SO_CFGW{1'b0}}),
    .so_ds	 ({3*SO_NSIDE{1'b0}}),
    .we_\(.*\)	 ({WE_NSIDE{1'b0}}),
    .we_cfg	 ({WE_CFGW{1'b0}}),
    .we_ds	 ({3*WE_NSIDE{1'b0}}),
    );
    */

   la_iopadring #(// north
		  .NO_SECTIONS(NO_SECTIONS),
		  .NO_NSIDE(NO_NSIDE),
		  .NO_NGPIO(NO_NGPIO),
		  .NO_NANALOG(NO_NANALOG),
		  .NO_NXTAL(NO_NXTAL),
		  .NO_NVDDIO(NO_NVDDIO),
		  .NO_NVDD(NO_NVDD),
		  .NO_NGND(NO_NGND),
		  .NO_NCLAMP(NO_NCLAMP),
		  // east
		  .EA_SECTIONS(EA_SECTIONS),
		  .EA_NSIDE(EA_NSIDE),
		  .EA_NGPIO(EA_NGPIO),
		  .EA_NANALOG(EA_NANALOG),
		  .EA_NXTAL(EA_NXTAL),
		  .EA_NVDDIO(EA_NVDDIO),
		  .EA_NVDD(EA_NVDD),
		  .EA_NGND(EA_NGND),
		  .EA_NCLAMP(EA_NCLAMP),
		  // south
		  .SO_SECTIONS(SO_SECTIONS),
		  .SO_NSIDE(SO_NSIDE),
		  .SO_NGPIO(SO_NGPIO),
		  .SO_NANALOG(SO_NANALOG),
		  .SO_NXTAL(SO_NXTAL),
		  .SO_NVDDIO(SO_NVDDIO),
		  .SO_NVDD(SO_NVDD),
		  .SO_NGND(SO_NGND),
		  .SO_NCLAMP(SO_NCLAMP),
		  // west
		  .WE_SECTIONS(WE_SECTIONS),
		  .WE_NSIDE(WE_NSIDE),
		  .WE_NGPIO(WE_NGPIO),
		  .WE_NANALOG(WE_NANALOG),
		  .WE_NXTAL(WE_NXTAL),
		  .WE_NVDDIO(WE_NVDDIO),
		  .WE_NVDD(WE_NVDD),
		  .WE_NGND(WE_NGND),
		  .WE_NCLAMP(WE_NCLAMP),
		  // globals
		  .CFGW(CFGW),
		  .RINGW(RINGW),
		  .ENPOC(ENPOC),
		  .ENCUT(ENCUT))
   dut (/*AUTOINST*/
	// Outputs
	.no_z				(no_z[NO_NSIDE-1:0]),	 // Templated
	.ea_z				(ea_z[EA_NSIDE-1:0]),	 // Templated
	.so_z				(so_z[SO_NSIDE-1:0]),	 // Templated
	.we_z				(we_z[WE_NSIDE-1:0]),	 // Templated
	// Inouts
	.vss				(vss),
	.no_pad				(no_pad[NO_NSIDE-1:0]),	 // Templated
	.no_vdd				(no_vdd[NO_SECTIONS-1:0]), // Templated
	.no_vddio			(no_vddio[NO_SECTIONS-1:0]), // Templated
	.no_vssio			(no_vssdio[NO_SECTIONS-1:0]), // Templated
	.ea_pad				(ea_pad[EA_NSIDE-1:0]),	 // Templated
	.ea_vdd				(ea_vdd[EA_SECTIONS-1:0]), // Templated
	.ea_vddio			(ea_vddio[EA_SECTIONS-1:0]), // Templated
	.ea_vssio			(ea_vssdio[EA_SECTIONS-1:0]), // Templated
	.so_pad				(so_pad[SO_NSIDE-1:0]),	 // Templated
	.so_vdd				(so_vdd[SO_SECTIONS-1:0]), // Templated
	.so_vddio			(so_vddio[SO_SECTIONS-1:0]), // Templated
	.so_vssio			(so_vssdio[SO_SECTIONS-1:0]), // Templated
	.we_pad				(we_pad[WE_NSIDE-1:0]),	 // Templated
	.we_vdd				(we_vdd[WE_SECTIONS-1:0]), // Templated
	.we_vddio			(we_vddio[WE_SECTIONS-1:0]), // Templated
	.we_vssio			(we_vssdio[WE_SECTIONS-1:0]), // Templated
	// Inputs
	.no_a				({NO_NSIDE{1'b0}}),	 // Templated
	.no_ie				({NO_NSIDE{1'b0}}),	 // Templated
	.no_oe				({NO_NSIDE{1'b0}}),	 // Templated
	.no_pe				({NO_NSIDE{1'b0}}),	 // Templated
	.no_ps				({NO_NSIDE{1'b0}}),	 // Templated
	.no_sr				({NO_NSIDE{1'b0}}),	 // Templated
	.no_st				({NO_NSIDE{1'b0}}),	 // Templated
	.no_ds				({3*NO_NSIDE{1'b0}}),	 // Templated
	.no_cfg				({NO_CFGW{1'b0}}),	 // Templated
	.ea_a				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_ie				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_oe				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_pe				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_ps				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_sr				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_st				({EA_NSIDE{1'b0}}),	 // Templated
	.ea_ds				({3*EA_NSIDE{1'b0}}),	 // Templated
	.ea_cfg				({EA_CFGW{1'b0}}),	 // Templated
	.so_a				({SO_NSIDE{1'b0}}),	 // Templated
	.so_ie				({SO_NSIDE{1'b0}}),	 // Templated
	.so_oe				({SO_NSIDE{1'b0}}),	 // Templated
	.so_pe				({SO_NSIDE{1'b0}}),	 // Templated
	.so_ps				({SO_NSIDE{1'b0}}),	 // Templated
	.so_sr				({SO_NSIDE{1'b0}}),	 // Templated
	.so_st				({SO_NSIDE{1'b0}}),	 // Templated
	.so_ds				({3*SO_NSIDE{1'b0}}),	 // Templated
	.so_cfg				({SO_CFGW{1'b0}}),	 // Templated
	.we_a				({WE_NSIDE{1'b0}}),	 // Templated
	.we_ie				({WE_NSIDE{1'b0}}),	 // Templated
	.we_oe				({WE_NSIDE{1'b0}}),	 // Templated
	.we_pe				({WE_NSIDE{1'b0}}),	 // Templated
	.we_ps				({WE_NSIDE{1'b0}}),	 // Templated
	.we_sr				({WE_NSIDE{1'b0}}),	 // Templated
	.we_st				({WE_NSIDE{1'b0}}),	 // Templated
	.we_ds				({3*WE_NSIDE{1'b0}}),	 // Templated
	.we_cfg				({WE_CFGW{1'b0}}));	 // Templated










endmodule // testbench
// Local Variables:
// verilog-library-directories:("../rtl" "../../oh/stdlib/testbench")
// End:
