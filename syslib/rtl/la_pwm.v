/*****************************************************************************
 * Function: Pulse Width Modulator
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_pwm
  #(
    parameter TYPE = "DEFAULT", // interface selection
    parameter PW   = 256,       // packet width
    parameter CW   = 16,        // counter width
    parameter CTRLW = 8,      // control vector width
    parameter STATW = 8       // status vector width
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
    // pwm interface
    input 	       pwm_en, // pwm counter enable input pin
    output 	       pwm_a, // channel a output pin
    output 	       pwm_b, // channel b output pin
    output 	       pwm_wrap // counter wrap indicator
    );

endmodule // la_pwm
