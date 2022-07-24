
module la_aoi31(a0, a1, a2, b0, z);
  input a0;
  input a1;
  input a2;
  input b0;
  output z;
  sky130_fd_sc_hd__a31oi_2 _0_ (
    .A1(a1),
    .A2(a0),
    .A3(a2),
    .B1(b0),
    .Y(z)
  );
endmodule
