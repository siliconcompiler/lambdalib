
module la_mux3(d0, d1, d2, s0, s1, z);
  wire _0_;
  input d0;
  input d1;
  input d2;
  input s0;
  input s1;
  output z;
  sky130_fd_sc_hd__mux2_1 _1_ (
    .A0(d0),
    .A1(d1),
    .S(s0),
    .X(_0_)
  );
  sky130_fd_sc_hd__mux2_1 _2_ (
    .A0(_0_),
    .A1(d2),
    .S(s1),
    .X(z)
  );
endmodule
