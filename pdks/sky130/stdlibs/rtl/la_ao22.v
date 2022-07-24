
module la_ao22(a0, a1, b0, b1, z);
  input a0;
  input a1;
  input b0;
  input b1;
  output z;
  sky130_fd_sc_hd__a22o_2 _0_ (
    .A1(a1),
    .A2(a0),
    .B1(b1),
    .B2(b0),
    .X(z)
  );
endmodule
