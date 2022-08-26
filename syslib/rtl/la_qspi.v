/*****************************************************************************
 * Function: QSPI Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * 1. Statically configurable as host/device by TYPE.

 ****************************************************************************/
module la_qspi
  #(
    parameter TYPE = "HOST", // interface selection ("HOST/DEVICE")
    parameter PW   = 256,    // packet width
    parameter CTRLW = 8,     // control vector width
    parameter STATW = 8      // status vector width
    )
   (// basic control signals
    input 	       clk, // core clock
    input 	       nreset, // active low async reset
    input [CTRLW-1:0]  ctrl, // free form ctrl inputs
    output [STATW-1:0] status, // free form status outputs
    // common memory mapped core interface
    input [PW-1:0]     tx_data,
    input 	       tx_valid,
    output 	       tx_ready,
    output [PW-1:0]    rx_data,
    output 	       rx_valid,
    input 	       rx_ready,
    // inputs
    input 	       qspi_clk_in,
    input 	       qspi_csn_in,
    input 	       qspi_io0_in,
    input 	       qspi_io1_in,
    input 	       qspi_io2_in,
    input 	       qspi_io3_in,
    // outputs
    output 	       qspi_clk_out,
    output 	       qspi_csn_out,
    output 	       qspi_io0_out,
    output 	       qspi_io1_out,
    output 	       qspi_io2_out,
    output 	       qspi_io3_out,
    // output enable
    output 	       qspi_clk_oe,
    output 	       qspi_csn_oe,
    output 	       qspi_io0_oe,
    output 	       qspi_io1_oe,
    output 	       qspi_io2_oe,
    output 	       qspi_io3_oe
    );

   generate
      if (TYPE=="HOST")
	begin
	   assign qspi_clk_oe = 1'b1;
	   assign qspi_csn_oe = 1'b1;
	end
      else
	begin
	   assign qspi_clk_oe = 1'b0;
	   assign qspi_csn_oe = 1'b0;
	end
   endgenerate

endmodule // la_qspi
