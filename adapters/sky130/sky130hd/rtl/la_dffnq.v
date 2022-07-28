
module la_dffnq(d, clk, q);
  wire _0_;
  input clk;
  input d;
  output q;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(clk),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfxtp_2 _2_ (
    .CLK(_0_),
    .D(d),
    .Q(q)
  );
endmodule
