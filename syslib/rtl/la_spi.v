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
    parameter TYPE = "HOST", // interface selection
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
    input 	       spi_sclk_in,
    input 	       spi_csn_in,
    input 	       spi_mosi_in,
    input 	       spi_miso_in,
    // outputs
    output 	       spi_sclk_out,
    output 	       spi_csn_out,
    output 	       spi_mosi_out,
    output 	       spi_miso_out,
    // output enable
    output 	       spi_sclk_oe,
    output 	       spi_csn_oe,
    output 	       spi_mosi_oe,
    output 	       spi_miso_oe
    );

   generate
      if (TYPE=="HOST")
	begin
	   assign spi_sclk_oe = 1'b1;
	   assign spi_csn_oe = 1'b1;
	   assign spi_mosi_oe = 1'b1;
	   assign spi_miso_oe = 1'b0;
	end
      else
	begin
	   assign spi_sclk_oe = 1'b0;
	   assign spi_csn_oe = 1'b0;
	   assign spi_mosi_oe = 1'b0;
	   assign spi_miso_oe = 1'b1;
	end
   endgenerate

endmodule // la_spi
