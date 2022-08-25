/*****************************************************************************
 * Function: SD/SDIO/MMC Host Controller
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_sd
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
    // sd interface
    output 	    sd_oen, // output enable for IO
    output 	    sd_clk, // clock from PHY
    input 	    sd_cd, // card detect
    input 	    sd_wp, // card write potect
    input 	    sd_cmd_in,
    input 	    sd_data0_in,
    input 	    sd_data1_in,
    input 	    sd_data2_in,
    input 	    sd_data3_in,
    output 	    sd_cmd_out,
    output 	    sd_data0_out,
    output 	    sd_data1_out,
    output 	    sd_data2_out,
    output 	    sd_data3_out
    );

endmodule // la_sd
