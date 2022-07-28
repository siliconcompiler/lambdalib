
module la_dffqn(d, clk, qn);
  wire _0_;
  input clk;
  input d;
  output qn;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(d),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfxtp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(qn)
  );
endmodule
