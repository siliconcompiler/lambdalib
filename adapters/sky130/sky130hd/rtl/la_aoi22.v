
module la_aoi22(a0, a1, b0, b1, z);
  input a0;
  input a1;
  input b0;
  input b1;
  output z;
  sky130_fd_sc_hd__a22oi_2 _0_ (
    .A1(b1),
    .A2(b0),
    .B1(a1),
    .B2(a0),
    .Y(z)
  );
endmodule
