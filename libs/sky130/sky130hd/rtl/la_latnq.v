
module la_latnq(d, clk, q);
  wire _0_;
  input clk;
  input d;
  output q;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(clk),
    .Y(_0_)
  );
  \$_DLATCH_P_  _2_ (
    .D(d),
    .E(_0_),
    .Q(q)
  );
endmodule
