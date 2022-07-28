
module la_clkinv(a, z);
  input a;
  output z;
  sky130_fd_sc_hd__inv_2 _0_ (
    .A(a),
    .Y(z)
  );
endmodule
