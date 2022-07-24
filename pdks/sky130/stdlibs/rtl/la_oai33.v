
module la_oai33(a0, a1, a2, b0, b1, b2, z);
  wire _0_;
  input a0;
  input a1;
  input a2;
  input b0;
  input b1;
  input b2;
  output z;
  sky130_fd_sc_hd__or3_2 _1_ (
    .A(b1),
    .B(b0),
    .C(b2),
    .X(_0_)
  );
  sky130_fd_sc_hd__o31ai_2 _2_ (
    .A1(a1),
    .A2(a0),
    .A3(a2),
    .B1(_0_),
    .Y(z)
  );
endmodule
