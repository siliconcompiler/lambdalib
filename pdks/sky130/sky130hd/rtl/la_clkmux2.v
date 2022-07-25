
module la_clkmux2(clk0, clk1, sel, z);
  input clk0;
  input clk1;
  input sel;
  output z;
  sky130_fd_sc_hd__mux2_1 _0_ (
    .A0(clk1),
    .A1(clk0),
    .S(sel),
    .X(z)
  );
endmodule
