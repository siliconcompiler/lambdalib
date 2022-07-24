
module la_iddr(clk, in, outrise, outfall);
  wire _0_;
  input clk;
  input in;
  wire inrise;
  output outfall;
  output outrise;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(clk),
    .Y(_0_)
  );
  sky130_fd_sc_hd__dfxtp_2 _2_ (
    .CLK(clk),
    .D(in),
    .Q(inrise)
  );
  sky130_fd_sc_hd__dfxtp_2 _3_ (
    .CLK(_0_),
    .D(in),
    .Q(outfall)
  );
  \$_DLATCH_P_  _4_ (
    .D(inrise),
    .E(_0_),
    .Q(outrise)
  );
endmodule
