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
    // jtag interface
    input 	    jtag_tms, // test mode select
    input 	    jtag_tck, // test clock
    input 	    jtag_trst, // test reset (optional)
    input 	    jtag_tdi, // test data in
    output 	    jtag_tdo  // test data out
    );

endmodule // la_jtag
