
module la_clkicgand(clk, te, en, eclk);
  wire _0_;
  wire _1_;
  input clk;
  output eclk;
  input en;
  wire en_stable;
  input te;
  sky130_fd_sc_hd__inv_2 _2_ (
    .A(clk),
    .Y(_1_)
  );
  sky130_fd_sc_hd__or2_2 _3_ (
    .A(te),
    .B(en),
    .X(_0_)
  );
  sky130_fd_sc_hd__and2_2 _4_ (
    .A(clk),
    .B(en_stable),
    .X(eclk)
  );
  \$_DLATCH_P_  _5_ (
    .D(_0_),
    .E(_1_),
    .Q(en_stable)
  );
endmodule
