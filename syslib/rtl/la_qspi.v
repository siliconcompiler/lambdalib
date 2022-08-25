/*****************************************************************************
 * Function: QSPI Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_qspi
  #(
    parameter TYPE = "DEFAULT" // interface selection
    parameter PW   = 256,      // packet width
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
    input 	    rx_ready
    // io interface
    output 	    sck, //serial clock
    output 	    csn, // active low chip select
    output 	    d0, // SI in spi mode or O0 in qspi mode
    output 	    d1, // SO in spi mode or O1 in qspi mode
    output 	    d2, // O2 in qspi mode
    output 	    d3 // O3 in qspi mode
    );

endmodule // la_qspi
