
module la_oa222(a0, a1, b0, b1, c0, c1, z);
  wire _0_;
  input a0;
  input a1;
  input b0;
  input b1;
  input c0;
  input c1;
  output z;
  sky130_fd_sc_hd__or2_2 _1_ (
    .A(a1),
    .B(a0),
    .X(_0_)
  );
  sky130_fd_sc_hd__o221a_2 _2_ (
    .A1(b1),
    .A2(b0),
    .B1(c1),
    .B2(c0),
    .C1(_0_),
    .X(z)
  );
endmodule
