
module la_dffq(d, clk, q);
  input clk;
  input d;
  output q;
  sky130_fd_sc_hd__dfxtp_2 _0_ (
    .CLK(clk),
    .D(d),
    .Q(q)
  );
endmodule
