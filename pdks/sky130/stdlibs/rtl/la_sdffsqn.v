
module la_sdffsqn(d, si, se, clk, nset, qn);
  wire _0_;
  wire _1_;
  input clk;
  input d;
  input nset;
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
  sky130_fd_sc_hd__dfrtp_2 _4_ (
    .CLK(clk),
    .D(_0_),
    .Q(qn),
    .RESET_B(nset)
  );
endmodule
