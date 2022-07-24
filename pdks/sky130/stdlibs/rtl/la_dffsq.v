
module la_dffsq(d, clk, nset, q);
  input clk;
  input d;
  input nset;
  output q;
  sky130_fd_sc_hd__dfstp_2 _0_ (
    .CLK(clk),
    .D(d),
    .Q(q),
    .SET_B(nset)
  );
endmodule
