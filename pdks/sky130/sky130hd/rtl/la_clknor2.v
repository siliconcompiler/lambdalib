
module la_clknor2(a, b, z);
  input a;
  input b;
  output z;
  sky130_fd_sc_hd__nor2_2 _0_ (
    .A(b),
    .B(a),
    .Y(z)
  );
endmodule
