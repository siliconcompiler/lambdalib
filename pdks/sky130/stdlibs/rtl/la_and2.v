
module la_and2(a, b, z);
  input a;
  input b;
  output z;
  sky130_fd_sc_hd__and2_2 _0_ (
    .A(b),
    .B(a),
    .X(z)
  );
endmodule
