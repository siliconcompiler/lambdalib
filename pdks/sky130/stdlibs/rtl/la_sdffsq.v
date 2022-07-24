
module la_sdffsq(d, si, se, clk, nset, q);
  wire _0_;
  input clk;
  input d;
  input nset;
  output q;
  input se;
  input si;
  sky130_fd_sc_hd__mux2_1 _1_ (
    .A0(d),
    .A1(si),
    .S(se),
    .X(_0_)
  );
  sky130_fd_sc_hd__dfstp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(q),
    .SET_B(nset)
  );
endmodule
