/*****************************************************************************
 * Function: GPIO Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_gpio
  #(
    parameter TYPE = "DEFAULT", // interface selection
    parameter PW   = 256,       // packet width
    parameter N    = 8,         // number of GPIO pins
    parameter CTRLW = 8,      // control vector width
    parameter STATW = 8       // status vector width
    )
   (// basic control signals
    input 	       clk, // core clock
    input 	       nreset, // active low async reset
    input [CTRLW-1:0]  ctrl, // free form ctrl inputs
    output [STATW-1:0] status, // free form status outputse
    // common memory mapped core interface
    input [PW-1:0]     tx_data,
    input 	       tx_valid,
    output 	       tx_ready,
    output [PW-1:0]    rx_data,
    output 	       rx_valid,
    input 	       rx_ready,
    // io interface
    input [N-1:0]      gpio_in, // data from IO pins
    output [N-1:0]     gpio_out, // data to drive to IO pins
    output [N-1:0]     gpio_oe, // output enable
    output 	       gpio_irq //global gpio interrupt (or-ed)
    );

endmodule // la_gpio
