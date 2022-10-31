/*****************************************************************************
 * Function: Shorting two wires together
 * Copyright: Lambda Project Authors. ALl rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * Workaround for unsupported tran, alias, and port aliasing in Verilator.
 *
 * Useful for making connections between ports without hard coding the
 * connection in RTL.
 *
 ****************************************************************************/
module la_ioshort
  (
   inout a,
   inout b,
   input a2b
   );

`ifdef VERILATOR
   // Using direction to break the loop
   assign a = a2b  ? b : 1'bz;
   assign b = ~a2b ? a : 1'bz;
`else
   la_pt la_pt(a,b);
`endif

endmodule // la_ioshort

//########################################
// THIS FUNCTION DOESN"T WORK IN VERILATOR
//########################################

`ifndef VERILATOR
// Hidden pass through function
module la_pt(a,a);
   inout a;
endmodule // la_pt
`endif
