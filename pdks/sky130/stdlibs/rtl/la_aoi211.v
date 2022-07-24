
module la_aoi211(a0, a1, b0, c0, z);
  input a0;
  input a1;
  input b0;
  input c0;
  output z;
  sky130_fd_sc_hd__a211oi_2 _0_ (
    .A1(a1),
    .A2(a0),
    .B1(b0),
    .C1(c0),
    .Y(z)
  );
endmodule
