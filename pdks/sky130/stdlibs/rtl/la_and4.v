
module la_and4(a, b, c, d, z);
  input a;
  input b;
  input c;
  input d;
  output z;
  sky130_fd_sc_hd__and4_2 _0_ (
    .A(b),
    .B(a),
    .C(c),
    .D(d),
    .X(z)
  );
endmodule
