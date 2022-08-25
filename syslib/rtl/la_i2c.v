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
    parameter TYPE = "DEFAULT", // interface selection
    parameter PW   = 256        // packet width
    )
   (// basic control signals
    input 	    clk, // core clock
    input 	    nreset, // active low async reset
    // common memory mapped core interface
    input [PW-1:0]  tx_data,
    input 	    tx_valid,
    output 	    tx_ready,
    output [PW-1:0] rx_data,
    output 	    rx_valid,
    input 	    rx_ready,
    // i2c shared host/device interface
    input 	    i2c_scl_in,
    output 	    i2c_scl_out,
    input 	    i2c_sda_in,
    output 	    i2c_sda_out,
    output 	    i2c_sda_oen, // output enable for sda
    output 	    i2c_scl_oen  // output enable for scl
    );

endmodule // la_i2c
