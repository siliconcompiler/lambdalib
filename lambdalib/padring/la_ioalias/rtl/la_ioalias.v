
/**************************************************************************
 * Function: IO Alias Utility Module
 * Copyright: Lambda Project Authors. All rights Reserved.
 * License:  MIT (see LICENSE file in Lambda repository)
 *
 * Docs:
 *
 * Signal renaming and concatenation of wires doesn't work for
 * directly connected I/O ports. One solution is to hard code the
 * connections in the design. Another option is to pass through the
 * name translation module shown below.
 *
 * WARNING: The port list alias features is in the verilog standard,
 * but not well supported by open source tools. Not recommended for
 * portable designs.
 *
 *************************************************************************/

module la_ioalias (.io1(a),
                   .io2(a));

   inout wire a;

endmodule
