
module la_and3(a, b, c, z);
  input a;
  input b;
  input c;
  output z;
  sky130_fd_sc_hd__and3_2 _0_ (
    .A(b),
    .B(a),
    .C(c),
    .X(z)
  );
endmodule
