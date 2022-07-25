
module la_dffsqn(d, clk, nset, qn);
  wire _0_;
  input clk;
  input d;
  input nset;
  output qn;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(d),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfrtp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(qn),
    .RESET_B(nset)
  );
endmodule
