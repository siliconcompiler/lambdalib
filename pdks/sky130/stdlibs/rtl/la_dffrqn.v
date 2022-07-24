
module la_dffrqn(d, clk, nreset, qn);
  wire _0_;
  input clk;
  input d;
  input nreset;
  output qn;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(d),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfstp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(qn),
    .SET_B(nreset)
  );
endmodule
