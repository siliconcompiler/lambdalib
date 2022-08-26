/*****************************************************************************
 * Function: I2C interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * Firmware configurable as host or device.
 *
 ****************************************************************************/
module la_i2c
  #(
    parameter TYPE = "HOST", // HOST/DEVICE
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
    input 	       i2c_scl_in,
    input 	       i2c_sda_in,
    // outputs
    output 	       i2c_scl_out,
    output 	       i2c_sda_out,
    // output enable
    output 	       i2c_scl_oe,
    output 	       i2c_sda_oe
    );

   generate
      if (TYPE=="HOST")
	begin
	   assign i2c_scl_oe = 1'b1;
	end
      else
	begin
	   assign i2c_scl_oe = 1'b0;
	end
   endgenerate

endmodule // la_i2c
