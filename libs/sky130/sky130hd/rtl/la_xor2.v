
module la_xor2(a, b, z);
  input a;
  input b;
  output z;
  sky130_fd_sc_hd__xor2_2 _0_ (
    .A(b),
    .B(a),
    .X(z)
  );
endmodule
