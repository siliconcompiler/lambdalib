
module la_clkicgor(clk, te, en, eclk);
  wire _0_;
  input clk;
  output eclk;
  input en;
  wire en_stable;
  input te;
  sky130_fd_sc_hd__or2_2 _1_ (
    .A(te),
    .B(en),
    .X(_0_)
  );
  sky130_fd_sc_hd__nand2b_2 _2_ (
    .A_N(clk),
    .B(en_stable),
    .Y(eclk)
  );
  \$_DLATCH_P_  _3_ (
    .D(_0_),
    .E(clk),
    .Q(en_stable)
  );
endmodule
