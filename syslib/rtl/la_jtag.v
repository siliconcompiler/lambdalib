/*****************************************************************************
 * Function: JTAG debug interface (device)
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * Firmware configurable as host or device.
 *
 ****************************************************************************/
module la_jtag
  #(
    parameter TYPE = "DEVICE", // interface selection
    parameter PW   = 256,      // packet width
    parameter CTRLW = 8,       // control vector width
    parameter STATW = 8        // status vector width
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
    input 	       jtag_tck_in,
    input 	       jtag_tms_in,
    input 	       jtag_trst_in,
    input 	       jtag_tdi_in,
    input 	       jtag_tdo_in,
    // outputs
    output 	       jtag_tck_out,
    output 	       jtag_tms_out,
    output 	       jtag_trst_out,
    output 	       jtag_tdi_out,
    output 	       jtag_tdo_out,
    // output enable
    output 	       jtag_tck_oe,
    output 	       jtag_tms_oe,
    output 	       jtag_trst_oe,
    output 	       jtag_tdi_oe,
    output 	       jtag_tdo_oe
    );

   generate
      if (TYPE=="HOST")
	begin
	   assign jtag_tms_oe = 1'b1;
	   assign jtag_trst_oe = 1'b1;
	   assign jtag_tdi_oe = 1'b1;
	   assign jtag_tck_oe = 1'b1;
	   assign jtag_tdo_oe = 1'b0;
	end
      else
	begin
	   assign jtag_tms_oe = 1'b0;
	   assign jtag_trst_oe = 1'b0;
	   assign jtag_tdi_oe = 1'b0;
	   assign jtag_tck_oe = 1'b0;
	   assign jtag_tdo_oe = 1'b1;
	end
   endgenerate

endmodule // la_jtag
