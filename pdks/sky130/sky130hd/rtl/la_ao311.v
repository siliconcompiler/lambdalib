
module la_ao311(a0, a1, a2, b0, c0, z);
  input a0;
  input a1;
  input a2;
  input b0;
  input c0;
  output z;
  sky130_fd_sc_hd__a311o_2 _0_ (
    .A1(a2),
    .A2(a1),
    .A3(a0),
    .B1(c0),
    .C1(b0),
    .X(z)
  );
endmodule
