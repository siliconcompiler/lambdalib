
module la_oa32(a0, a1, a2, b0, b1, z);
  input a0;
  input a1;
  input a2;
  input b0;
  input b1;
  output z;
  sky130_fd_sc_hd__o32a_2 _0_ (
    .A1(a2),
    .A2(a1),
    .A3(a0),
    .B1(b1),
    .B2(b0),
    .X(z)
  );
endmodule
