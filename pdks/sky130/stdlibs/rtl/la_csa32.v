
module la_csa32(a, b, c, sum, carry);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input a;
  input b;
  input c;
  output carry;
  output sum;
  sky130_fd_sc_hd__or3_2 _4_ (
    .A(b),
    .B(a),
    .C(c),
    .X(_0_)
  );
  sky130_fd_sc_hd__nand2_2 _5_ (
    .A(a),
    .B(c),
    .Y(_1_)
  );
  sky130_fd_sc_hd__and3_2 _6_ (
    .A(b),
    .B(a),
    .C(c),
    .X(_2_)
  );
  sky130_fd_sc_hd__o21ai_2 _7_ (
    .A1(a),
    .A2(c),
    .B1(b),
    .Y(_3_)
  );
  sky130_fd_sc_hd__nand2_2 _8_ (
    .A(_1_),
    .B(_3_),
    .Y(carry)
  );
  sky130_fd_sc_hd__a31o_2 _9_ (
    .A1(_0_),
    .A2(_1_),
    .A3(_3_),
    .B1(_2_),
    .X(sum)
  );
endmodule
