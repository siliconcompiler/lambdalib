
module la_sdffrqn(d, si, se, clk, nreset, qn);
  wire _0_;
  wire _1_;
  input clk;
  input d;
  input nreset;
  output qn;
  input se;
  input si;
  sky130_fd_sc_hd__mux2_1 _2_ (
    .A0(d),
    .A1(si),
    .S(se),
    .X(_1_)
  );
  sky130_fd_sc_hd__inv_2 _3_ (
    .A(_1_),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfstp_2 _4_ (
    .CLK(clk),
    .D(_0_),
    .Q(qn),
    .SET_B(nreset)
  );
endmodule
