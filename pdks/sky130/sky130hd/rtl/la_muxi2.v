
module la_muxi2(d0, d1, s, z);
  wire _0_;
  input d0;
  input d1;
  input s;
  output z;
  sky130_fd_sc_hd__mux2_1 _1_ (
    .A0(d0),
    .A1(d1),
    .S(s),
    .X(_0_)
  );
  sky130_fd_sc_hd__inv_2 _2_ (
    .A(_0_),
    .Y(z)
  );
endmodule
