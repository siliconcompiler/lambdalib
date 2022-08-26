/*****************************************************************************
 * Function: Ethernet Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_eth
  #(
    parameter TYPE = "DEFAULT", // interface selection
    parameter PW   = 256,       // packet width
    parameter CTRLW = 8,       // control vector width
    parameter STATW = 8        // status vector width
    )
   (// basic control signals
    input 	       clk, // core clock
    input 	       nreset, // active low async reset
    input [CTRLW-1:0]  ctrl, // free form ctrl inputs
    output [STATW-1:0] status, // free form status outputs
    // core interface
    input [PW-1:0]     tx_data,
    input 	       tx_valid,
    output 	       tx_ready,
    output [PW-1:0]    rx_data,
    output 	       rx_valid,
    input 	       rx_ready,
    // gmii interface
    input [7:0]        gmii_rx_data,
    input 	       gmii_rx_valid,
    input 	       gmii_rx_error,
    output 	       gmii_tx_clk,
    output [7:0]       gmii_tx_data,
    output 	       gmii_tx_enable,
    output 	       gmii_tx_error,
    // rgmii interface
    input [3:0]        rgmii_rx_data,
    input 	       rgmii_rx_ctl,
    input 	       rgmii_rx_mdc,
    input 	       rgmii_rx_mdin,
    output 	       rgmii_rx_mdout,
    output 	       rgmii_rx_mden,
    output 	       rgmii_tx_clk,
    output [3:0]       rgmii_tx_data,
    output 	       rgmii_tx_ctl
    );

endmodule // la_eth
