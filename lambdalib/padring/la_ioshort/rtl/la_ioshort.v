/**************************************************************************
 * Function: Simulation Friendly IO Alias Module
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * Instantiates the la_ioalias inout alias module and adds a loop breaking
 * logic for some tools that don's support tran, alias,and port aliasing.
 *
 * WARNING: The port list alias features is in the verilog standard,
 * but not well supported by open source tools. Not recommended for
 * portable designs.
 *
 *************************************************************************/
module la_ioshort (inout a,
                   inout b,
                   input a2b
                   );

`ifdef VERILATOR
   // Using direction to break the loop
   assign a = ~a2b ? b : 1'bz;
   assign b = a2b ? a : 1'bz;
`else
    // verilog_lint: waive-start module-port
    la_pt la_ioalias (a,b);
    // verilog_lint: waive-end module-port
`endif

endmodule
