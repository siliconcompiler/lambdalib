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
    // uart interface
    input 	    uart_rx, // data from io
    output 	    uart_tx, // data to io
    output 	    uart_tx_busy,
    output 	    uart_rx_busy,
    output 	    uart_error
    );

endmodule // la_uart
