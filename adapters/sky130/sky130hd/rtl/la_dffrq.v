
module la_dffrq(d, clk, nreset, q);
  input clk;
  input d;
  input nreset;
  output q;
  sky130_fd_sc_hd__dfrtp_2 _0_ (
    .CLK(clk),
    .D(d),
    .Q(q),
    .RESET_B(nreset)
  );
endmodule
