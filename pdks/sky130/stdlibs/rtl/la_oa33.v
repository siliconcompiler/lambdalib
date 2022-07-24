
module la_oa33(a0, a1, a2, b0, b1, b2, z);
  wire _0_;
  input a0;
  input a1;
  input a2;
  input b0;
  input b1;
  input b2;
  output z;
  sky130_fd_sc_hd__or3_2 _1_ (
    .A(a2),
    .B(a1),
    .C(a0),
    .X(_0_)
  );
  sky130_fd_sc_hd__o31a_2 _2_ (
    .A1(b2),
    .A2(b1),
    .A3(b0),
    .B1(_0_),
    .X(z)
  );
endmodule
