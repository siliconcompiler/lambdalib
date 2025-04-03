module ddr_simulation_bug (
  input        clk,
  input  [1:0] d_in,
  output [1:0] d_out
);

  wire ddr_data;
  la_oddr oddr  (.clk(clk), .in0(d_in[0]), .in1(d_in[1]), .out(ddr_data));
  la_iddr iddr  (.clk(clk), .in(ddr_data), .outrise(d_out[0]), .outfall(d_out[1]));

endmodule
