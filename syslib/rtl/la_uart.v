/*****************************************************************************
 * Function: UART interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_uart
  #(
    parameter TYPE = "DEFAULT", // interface selection
    parameter PW   = 256,        // packet width
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
    // uart interface
    input 	       uart_rx, // data from io
    output 	       uart_tx, // data to io
    output 	       uart_error
    );

endmodule // la_uart
