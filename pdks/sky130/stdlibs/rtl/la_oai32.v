
module la_oai32(a0, a1, a2, b0, b1, z);
  input a0;
  input a1;
  input a2;
  input b0;
  input b1;
  output z;
  sky130_fd_sc_hd__o32ai_2 _0_ (
    .A1(a1),
    .A2(a0),
    .A3(a2),
    .B1(b1),
    .B2(b0),
    .Y(z)
  );
endmodule
