
module la_latq(d, clk, q);
  input clk;
  input d;
  output q;
  \$_DLATCH_P_  _0_ (
    .D(d),
    .E(clk),
    .Q(q)
  );
endmodule
