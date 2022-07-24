
module la_muxi3(d0, d1, d2, s0, s1, z);
  wire _0_;
  wire _1_;
  input d0;
  input d1;
  input d2;
  input s0;
  input s1;
  output z;
  sky130_fd_sc_hd__mux2_1 _2_ (
    .A0(d0),
    .A1(d1),
    .S(s0),
    .X(_0_)
  );
  sky130_fd_sc_hd__nand2b_2 _3_ (
    .A_N(d2),
    .B(s1),
    .Y(_1_)
  );
  sky130_fd_sc_hd__o21ai_2 _4_ (
    .A1(s1),
    .A2(_0_),
    .B1(_1_),
    .Y(z)
  );
endmodule
