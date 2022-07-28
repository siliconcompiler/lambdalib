
module la_oa311(a0, a1, a2, b0, c0, z);
  input a0;
  input a1;
  input a2;
  input b0;
  input c0;
  output z;
  sky130_fd_sc_hd__o311a_2 _0_ (
    .A1(a1),
    .A2(a0),
    .A3(a2),
    .B1(b0),
    .C1(c0),
    .X(z)
  );
endmodule
