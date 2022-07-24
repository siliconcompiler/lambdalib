
module la_latnq
  #(parameter TYPE = "DEFAULT")
   (
    input  d,
    input  clk,
    output q
    );

   sky130_fd_sc_hd__dlxtn_1
     lat0 (.D(d),
	   .GATE_N(clk),
           .Q(q)
           );

endmodule
