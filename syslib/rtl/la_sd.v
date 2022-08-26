/*****************************************************************************
 * Function: SD/SDIO/MMC Controller
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_sd
  #(
    parameter TYPE = "HOST", // HOST/DEVICE
    parameter PW   = 256,    // packet width
    parameter CTRLW = 8,     // control vector width
    parameter STATW = 8      // status vector width
    )
   (// basic control signalsx
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
    input 	       sd_clk_in,
    input 	       sd_cd_in,
    input 	       sd_wp_in,
    input 	       sd_cmd_in,
    input 	       sd_dat0_in,
    input 	       sd_dat1_in,
    input 	       sd_dat2_in,
    input 	       sd_dat3_in,
    // outputs
    output 	       sd_clk_out,
    output 	       sd_cd_out,
    output 	       sd_wp_out,
    output 	       sd_cmd_out,
    output 	       sd_dat0_out,
    output 	       sd_dat1_out,
    output 	       sd_dat2_out,
    output 	       sd_dat3_out,
    // enables
    output 	       sd_clk_oe,
    output 	       sd_cd_oe,
    output 	       sd_wp_oe,
    output 	       sd_cmd_oe,
    output 	       sd_dat0_oe,
    output 	       sd_dat1_oe,
    output 	       sd_dat2_oe,
    output 	       sd_dat3_oe
    );

endmodule // la_sd
