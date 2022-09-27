module testbench();


   initial
     begin
	$dumpvars();
     end

   parameter           CFGW         = 8;
   parameter           RINGW        = 8;
   // per side settings
   parameter [7:0]     NO_NPINS     =  8'h5; //xtal is an extra pin
   parameter [7:0]     NO_NCELLS    =  8'h10;
   parameter [7:0]     NO_NSECTIONS =  8'h2;
   parameter [2048:0]  NO_CELLTYPE  =  2048'h0F_0E_0D_0C_0B_0A_09_08_07_06_05_04_03_02_01_00;
   parameter [2048:0]  NO_PINMAP    =  2048'h00_00_00_00_03_02_01_00;
   parameter [2048:0]  NO_CUTMAP    =  2048'h01_01_01_00_00_00_00_00;
   parameter [7:0]     EA_NPINS     =  8'h1;
   parameter [7:0]     EA_NCELLS    =  8'h1;
   parameter [7:0]     EA_NSECTIONS =  8'h2;
   parameter [2048:0]  EA_CELLTYPE  =  2048'h0;
   parameter [2048:0]  EA_PINMAP    =  2048'h0;
   parameter [2048:0]  EA_CUTMAP    =  2048'h0;
   parameter [7:0]     SO_NPINS     =  8'h1;
   parameter [7:0]     SO_NCELLS    =  8'h1;
   parameter [7:0]     SO_NSECTIONS =  8'h1;
   parameter [2048:0]  SO_CELLTYPE  =  2048'h0;
   parameter [2048:0]  SO_PINMAP    =  2048'h0;
   parameter [2048:0]  SO_CUTMAP    =  2048'h0;
   parameter [7:0]     WE_NPINS     =  8'h1;
   parameter [7:0]     WE_NCELLS    =  8'h1;
   parameter [7:0]     WE_NSECTIONS =  8'h1;
   parameter [2048:0]  WE_CELLTYPE  =  2048'h0;
   parameter [2048:0]  WE_PINMAP    =  2048'h0;
   parameter [2048:0]  WE_CUTMAP    =  2048'h0;


   wire [EA_NPINS-1:0]	ea_a;			// To dut of la_iopadring.v
   wire [EA_NPINS*CFGW-1:0] ea_cfg;		// To dut of la_iopadring.v
   wire [EA_NPINS-1:0]	ea_ie;			// To dut of la_iopadring.v
   wire [EA_NPINS-1:0]	ea_oe;			// To dut of la_iopadring.v
   wire [NO_NPINS-1:0]	no_a;			// To dut of la_iopadring.v
   wire [NO_NPINS*CFGW-1:0] no_cfg;		// To dut of la_iopadring.v
   wire [NO_NPINS-1:0]	no_ie;			// To dut of la_iopadring.v
   wire [NO_NPINS-1:0]	no_oe;			// To dut of la_iopadring.v
   wire [SO_NPINS-1:0]	so_a;			// To dut of la_iopadring.v
   wire [SO_NPINS*CFGW-1:0] so_cfg;		// To dut of la_iopadring.v
   wire [SO_NPINS-1:0]	so_ie;			// To dut of la_iopadring.v
   wire [SO_NPINS-1:0]	so_oe;			// To dut of la_iopadring.v
   wire [WE_NPINS-1:0]	we_a;			// To dut of la_iopadring.v
   wire [WE_NPINS*CFGW-1:0] we_cfg;		// To dut of la_iopadring.v
   wire [WE_NPINS-1:0]	we_ie;			// To dut of la_iopadring.v
   wire [WE_NPINS-1:0] 	we_oe;			// To dut of la_iopadring.v

   /*AUTOINPUT*/
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [EA_NPINS*3-1:0] ea_aio;		// To/From dut of la_iopadring.v
   wire [EA_NSECTIONS*RINGW-1:0] ea_ioring;	// To/From dut of la_iopadring.v
   wire [EA_NPINS-1:0]	ea_pad;			// To/From dut of la_iopadring.v
   wire [EA_NSECTIONS-1:0] ea_vdd;		// To/From dut of la_iopadring.v
   wire [EA_NSECTIONS-1:0] ea_vddio;		// To/From dut of la_iopadring.v
   wire [EA_NSECTIONS-1:0] ea_vssio;		// To/From dut of la_iopadring.v
   wire [EA_NPINS-1:0]	ea_z;			// From dut of la_iopadring.v
   wire [NO_NPINS*3-1:0] no_aio;		// To/From dut of la_iopadring.v
   wire [NO_NSECTIONS*RINGW-1:0] no_ioring;	// To/From dut of la_iopadring.v
   wire [NO_NPINS-1:0]	no_pad;			// To/From dut of la_iopadring.v
   wire [NO_NSECTIONS-1:0] no_vdd;		// To/From dut of la_iopadring.v
   wire [NO_NSECTIONS-1:0] no_vddio;		// To/From dut of la_iopadring.v
   wire [NO_NSECTIONS-1:0] no_vssio;		// To/From dut of la_iopadring.v
   wire [NO_NPINS-1:0]	no_z;			// From dut of la_iopadring.v
   wire [SO_NPINS*3-1:0] so_aio;		// To/From dut of la_iopadring.v
   wire [SO_NSECTIONS*RINGW-1:0] so_ioring;	// To/From dut of la_iopadring.v
   wire [SO_NPINS-1:0]	so_pad;			// To/From dut of la_iopadring.v
   wire [SO_NSECTIONS-1:0] so_vdd;		// To/From dut of la_iopadring.v
   wire [SO_NSECTIONS-1:0] so_vddio;		// To/From dut of la_iopadring.v
   wire [SO_NSECTIONS-1:0] so_vssio;		// To/From dut of la_iopadring.v
   wire [SO_NPINS-1:0]	so_z;			// From dut of la_iopadring.v
   wire			vss;			// To/From dut of la_iopadring.v
   wire [WE_NPINS*3-1:0] we_aio;		// To/From dut of la_iopadring.v
   wire [WE_NSECTIONS*RINGW-1:0] we_ioring;	// To/From dut of la_iopadring.v
   wire [WE_NPINS-1:0]	we_pad;			// To/From dut of la_iopadring.v
   wire [WE_NSECTIONS-1:0] we_vdd;		// To/From dut of la_iopadring.v
   wire [WE_NSECTIONS-1:0] we_vddio;		// To/From dut of la_iopadring.v
   wire [WE_NSECTIONS-1:0] we_vssio;		// To/From dut of la_iopadring.v
   wire [WE_NPINS-1:0]	we_z;			// From dut of la_iopadring.v
   // End of automatics



   //#################################
   // DUT
   //#################################

   /*la_iopadring AUTO_TEMPLATE (//outputs
    );
    */

   la_iopadring #(.RINGW(RINGW),
		  .CFGW(CFGW),
		  .NO_NPINS(NO_NPINS),
		  .NO_NCELLS(NO_NCELLS),
		  .NO_NSECTIONS(NO_NSECTIONS),
		  .NO_CELLTYPE(NO_CELLTYPE),
		  .NO_PINMAP(NO_PINMAP),
		  .NO_CUTMAP(NO_CUTMAP),
		  .EA_NPINS(EA_NPINS),
		  .EA_NCELLS(EA_NCELLS),
		  .EA_NSECTIONS(EA_NSECTIONS),
		  .EA_CELLTYPE(EA_CELLTYPE),
		  .EA_PINMAP(EA_PINMAP),
		  .EA_CUTMAP(EA_CUTMAP),
		  .SO_NPINS(SO_NPINS),
		  .SO_NCELLS(SO_NCELLS),
		  .SO_NSECTIONS(SO_NSECTIONS),
		  .SO_CELLTYPE(SO_CELLTYPE),
		  .SO_PINMAP(SO_PINMAP),
		  .SO_CUTMAP(SO_CUTMAP),
		  .WE_NPINS(WE_NPINS),
		  .WE_NCELLS(WE_NCELLS),
		  .WE_NSECTIONS(WE_NSECTIONS),
		  .WE_CELLTYPE(WE_CELLTYPE),
		  .WE_PINMAP(WE_PINMAP),
		  .WE_CUTMAP(WE_CUTMAP))

   dut (/*AUTOINST*/
	// Outputs
	.no_z				(no_z[NO_NPINS-1:0]),
	.ea_z				(ea_z[EA_NPINS-1:0]),
	.so_z				(so_z[SO_NPINS-1:0]),
	.we_z				(we_z[WE_NPINS-1:0]),
	// Inouts
	.vss				(vss),
	.no_pad				(no_pad[NO_NPINS-1:0]),
	.no_aio				(no_aio[NO_NPINS*3-1:0]),
	.no_vdd				(no_vdd[NO_NSECTIONS-1:0]),
	.no_vddio			(no_vddio[NO_NSECTIONS-1:0]),
	.no_vssio			(no_vssio[NO_NSECTIONS-1:0]),
	.no_ioring			(no_ioring[NO_NSECTIONS*RINGW-1:0]),
	.ea_pad				(ea_pad[EA_NPINS-1:0]),
	.ea_aio				(ea_aio[EA_NPINS*3-1:0]),
	.ea_vdd				(ea_vdd[EA_NSECTIONS-1:0]),
	.ea_vddio			(ea_vddio[EA_NSECTIONS-1:0]),
	.ea_vssio			(ea_vssio[EA_NSECTIONS-1:0]),
	.ea_ioring			(ea_ioring[EA_NSECTIONS*RINGW-1:0]),
	.so_pad				(so_pad[SO_NPINS-1:0]),
	.so_aio				(so_aio[SO_NPINS*3-1:0]),
	.so_vdd				(so_vdd[SO_NSECTIONS-1:0]),
	.so_vddio			(so_vddio[SO_NSECTIONS-1:0]),
	.so_vssio			(so_vssio[SO_NSECTIONS-1:0]),
	.so_ioring			(so_ioring[SO_NSECTIONS*RINGW-1:0]),
	.we_pad				(we_pad[WE_NPINS-1:0]),
	.we_aio				(we_aio[WE_NPINS*3-1:0]),
	.we_vdd				(we_vdd[WE_NSECTIONS-1:0]),
	.we_vddio			(we_vddio[WE_NSECTIONS-1:0]),
	.we_vssio			(we_vssio[WE_NSECTIONS-1:0]),
	.we_ioring			(we_ioring[WE_NSECTIONS*RINGW-1:0]),
	// Inputs
	.no_a				(no_a[NO_NPINS-1:0]),
	.no_ie				(no_ie[NO_NPINS-1:0]),
	.no_oe				(no_oe[NO_NPINS-1:0]),
	.no_cfg				(no_cfg[NO_NPINS*CFGW-1:0]),
	.ea_a				(ea_a[EA_NPINS-1:0]),
	.ea_ie				(ea_ie[EA_NPINS-1:0]),
	.ea_oe				(ea_oe[EA_NPINS-1:0]),
	.ea_cfg				(ea_cfg[EA_NPINS*CFGW-1:0]),
	.so_a				(so_a[SO_NPINS-1:0]),
	.so_ie				(so_ie[SO_NPINS-1:0]),
	.so_oe				(so_oe[SO_NPINS-1:0]),
	.so_cfg				(so_cfg[SO_NPINS*CFGW-1:0]),
	.we_a				(we_a[WE_NPINS-1:0]),
	.we_ie				(we_ie[WE_NPINS-1:0]),
	.we_oe				(we_oe[WE_NPINS-1:0]),
	.we_cfg				(we_cfg[WE_NPINS*CFGW-1:0]));










endmodule // testbench
// Local Variables:
// verilog-library-directories:("../rtl" "../../../oh/stdlib/testbench")
// End:
