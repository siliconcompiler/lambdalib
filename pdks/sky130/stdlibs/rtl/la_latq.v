
module la_latq
  #(parameter TYPE = "DEFAULT")
   (
    input  d,
    input  clk,
    output q
    );

   sky130_fd_sc_hd__dlxtp_1
     lat1 (.D(d),
	   .GATE(clk),
           .Q(q)
           );

endmodule
