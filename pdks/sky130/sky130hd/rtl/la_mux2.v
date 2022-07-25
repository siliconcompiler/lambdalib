
module la_mux2(d0, d1, s, z);
  input d0;
  input d1;
  input s;
  output z;
  sky130_fd_sc_hd__mux2_1 _0_ (
    .A0(d0),
    .A1(d1),
    .S(s),
    .X(z)
  );
endmodule
