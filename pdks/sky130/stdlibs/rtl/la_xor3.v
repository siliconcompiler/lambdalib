
module la_xor3(a, b, c, z);
  wire _0_;
  input a;
  input b;
  input c;
  output z;
  sky130_fd_sc_hd__xnor2_2 _1_ (
    .A(a),
    .B(c),
    .Y(_0_)
  );
  sky130_fd_sc_hd__xnor2_2 _2_ (
    .A(b),
    .B(_0_),
    .Y(z)
  );
endmodule
