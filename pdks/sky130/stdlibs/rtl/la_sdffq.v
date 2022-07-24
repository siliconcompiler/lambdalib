
module la_sdffq(d, si, se, clk, q);
  wire _0_;
  input clk;
  input d;
  output q;
  input se;
  input si;
  sky130_fd_sc_hd__mux2_1 _1_ (
    .A0(d),
    .A1(si),
    .S(se),
    .X(_0_)
  );
  sky130_fd_sc_hd__dfxtp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(q)
  );
endmodule
