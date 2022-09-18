/*****************************************************************************
 * Function: SPI Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_spi
  #(
    parameter TYPE    = "HOST", // interface selection
    parameter UW      = 256,    // packet width
    parameter CTRLW   = 8,      // control vector width
    parameter STATUSW = 8       // status vector width
    )
   (// basic control signals
    input 	       clk, // core clock
    input 	       nreset, // active low async reset
    input 	       hostmode, // 1=hostmode
    input [CTRLW-1:0]  ctrl, // free form ctrl inputs
    output [STATW-1:0] status, // free form status outputs
    // umi interface
    input 	       valid_in,
    input [UW-1:0]     packet_in,
    output 	       ready_out,
    output 	       valid_out,
    output [UW-1:0]    packet_out,
    input 	       ready_in
    // io interface
    input 	       spi_sck_in, // serial clock
    output 	       spi_sck_out,
    output 	       spi_sck_oe,
    input 	       spi_csn_in, // chip select (active low)
    output 	       spi_csn_out,
    output 	       spi_csn_oe,
    input 	       spi_sd_in, // serial data
    output 	       spi_sd_out,
    output 	       spi_sd_oe
    );

   assign spi_sck_oe = hostmode ? 1'b1 : 1'b0;
   assign spi_csn_oe = hostmode ? 1'b1 : 1'b0;
   assign spi_sd_oe  = hostmode ? 1'b1 : 1'b0;

endmodule // la_spi
