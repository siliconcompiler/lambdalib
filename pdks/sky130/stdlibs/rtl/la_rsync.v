
module la_rsync(clk, nrst_in, nrst_out);
  wire _0_;
  input clk;
  input nrst_in;
  output nrst_out;
  wire [1:0] sync_pipe;
  sky130_fd_sc_hd__conb_1 _1_ (
    .HI(_0_)
  );
  sky130_fd_sc_hd__dfrtp_2 _2_ (
    .CLK(clk),
    .D(_0_),
    .Q(sync_pipe[0]),
    .RESET_B(nrst_in)
  );
  sky130_fd_sc_hd__dfrtp_2 _3_ (
    .CLK(clk),
    .D(sync_pipe[0]),
    .Q(nrst_out),
    .RESET_B(nrst_in)
  );
  assign sync_pipe[1] = nrst_out;
endmodule
