
module la_dsync(clk, nreset, in, out);
  input clk;
  input in;
  input nreset;
  output out;
  wire [1:0] sync_pipe;
  sky130_fd_sc_hd__dfrtp_2 _0_ (
    .CLK(clk),
    .D(in),
    .Q(sync_pipe[0]),
    .RESET_B(nreset)
  );
  sky130_fd_sc_hd__dfrtp_2 _1_ (
    .CLK(clk),
    .D(sync_pipe[0]),
    .Q(out),
    .RESET_B(nreset)
  );
  assign sync_pipe[1] = out;
endmodule
