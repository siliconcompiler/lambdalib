
module la_ao21(a0, a1, b0, z);
  input a0;
  input a1;
  input b0;
  output z;
  sky130_fd_sc_hd__a21o_2 _0_ (
    .A1(a1),
    .A2(a0),
    .B1(b0),
    .X(z)
  );
endmodule
