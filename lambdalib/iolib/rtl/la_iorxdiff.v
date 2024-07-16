/*****************************************************************************
 * Function: IO differential receiver
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * This is a generic cell that defines the standard interface of the lambda
 * bidrectional buffer cell. It is only suitable for FPGA synthesis.
 *
 * ASIC specific libraries will need to use the TYPE field to select an
 * appropriate hardcoded physical cell based on the the process constraints
 * and library composition. For example, modern nodes will usually have
 * different IP cells for the placing cells vvertically or horizontally.
 *
 ****************************************************************************/
module la_iorxdiff
  #(
    parameter TYPE  = "DEFAULT",  // cell type
    parameter SIDE  = "NO",       // "NO", "SO", "EA", "WE"
    parameter CFGW  = 16,         // width of core config bus
    parameter RINGW = 8           // width of io ring
    )
   (// io pad signals
    inout             pad_p, // differential pad input (positive)
    inout             pad_n, // differential pad input (negative)
    inout             vdd, // core supply
    inout             vss, // core ground
    inout             vddio, // io supply
    inout             vssio, // io ground
    // core facing signals
    output            z_p, // digital output to core (positive)
    output            z_n, // digital output to core (negative)
    input             ie, // input enable, 1 = active
    inout [RINGW-1:0] ioring, // generic io-ring interface
    input [ CFGW-1:0] cfg // generic config interface
    );

   // gated differential non inverting buffer
   assign z_p = pad_p & ~pad_n & ie;

   // driving pseudo differential digital signal to core
   assign z_n = ~z_p;

endmodule
