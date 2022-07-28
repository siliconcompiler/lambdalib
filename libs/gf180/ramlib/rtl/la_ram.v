module la_ram
  #(parameter N      = 32,            // Memory width
    parameter DEPTH  = 32,            // Memory depth
    parameter TYPE   = "DEFAULT",     // pass through variable for hard macro
    parameter REG    = 1,             // adds pipeline stage to RAM
    parameter AW     = $clog2(DEPTH), // address width (derived)
    parameter CFGW   = 128,           // width of config interface
    parameter TESTW  = 128            // width of test interface
    )

   (// ram interface
    input 	      clk, // clock
    input 	      ce, // chip enable
    input 	      we, // write enable
    input [N-1:0]     wmask, // per bit write mask
    input [AW-1:0]    addr,// write address
    input [N-1:0]     din, // write data
    input [N-1:0]     dout, // read back data
    // Power signals
    input 	      vss, // ground signal
    input 	      vdd, // memory core array power
    input 	      vddio, // periphery/io power
    // Generic interfaces
    input [CFGW-1:0]  cfg, // generic config/test interface
    input [TESTW-1:0] test // generic test interface
    );

   generate
      if (TYPE == "DEFAULT")
	initial
	  begin
	     $display("ERROR: No Memory selected");
	     $finish();
	  end
      else if (TYPE == "gf180mcu_fd_ip_sram__sram512x8m8wm1")
	begin
	   gf180mcu_fd_ip_sram__sram512x8m8wm1
	     mem (// interface
		  .CLK(clk),
		  .CEN(ce),
		  .GWEN(we),
		  .WEN(wmask[7:0]),
		  .A(addr[8:0]),
		  .D(din[7:0]),
		  .Q(dout[7:0]),
		  .VDD(vdd),
		  .VSS(vss));
	end
      else if (TYPE == "gf180mcu_fd_ip_sram__sram64x8m8wm1")
	begin
	   gf180mcu_fd_ip_sram__sram64x8m8wm1
	     mem (// interface
		  .CLK(clk),
		  .CEN(ce),
		  .GWEN(we),
		  .WEN(wmask[7:0]),
		  .A(addr[5:0]),
		  .D(din[7:0]),
		  .Q(dout[7:0]),
		  .VDD(vdd),
		  .VSS(vss));
	end
   endgenerate

endmodule
