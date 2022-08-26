/*****************************************************************************
 * Function: USB Interface
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 ****************************************************************************/
module la_usb
  #(
    parameter TYPE  = "HOST", // HOST/DEVICE/OTG
    parameter PW    = 256,    // packet width
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
    // low/full speed
    input 	       usb_oen, // output enable for bidir signals
    output 	       usb_dp_out, // data output (pos)
    output 	       usb_dn_out, // data output (neg)
    input 	       usb_dp_in, // data input (pos)
    input 	       usb_dn_in, // data input (pos)
    input 	       usb_id, // indicates initial usb role for otg
    // ulpi
    input 	       ulpi_clk, // clock from PHY
    input 	       ulpi_dir, // data direction control from PHY
    input 	       ulpi_nxt, // nxt throttle
    output 	       ulpi_stp, // end of packet from link
    input [7:0]        ulpi_data_in, // data bus
    output [7:0]       ulpi_data_out,
    output 	       ulpi_oen // output enable for bidir signals
    );

endmodule // la_usb
