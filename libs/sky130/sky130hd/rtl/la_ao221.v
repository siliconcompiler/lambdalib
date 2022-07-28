
module la_ao221(a0, a1, b0, b1, c0, z);
  input a0;
  input a1;
  input b0;
  input b1;
  input c0;
  output z;
  sky130_fd_sc_hd__a221o_2 _0_ (
    .A1(b1),
    .A2(b0),
    .B1(a1),
    .B2(a0),
    .C1(c0),
    .X(z)
  );
endmodule
