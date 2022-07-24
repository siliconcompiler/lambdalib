//#############################################################################
//# Function: 2:1 Clock Mux                                                   #
//#############################################################################
//# Author:   Andreas Olofsson                                                #
//# License:  MIT (see LICENSE file in Lambda! repository)                        #
//#############################################################################

module la_clkmux2 #(parameter PROP = "DEFAULT")   (
    input  clk0,
    input  clk1,
    input  sel,
    output z
    );

   assign z = sel ? clk0 : clk1;

endmodule
