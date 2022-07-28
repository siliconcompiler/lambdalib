
module la_oddr(clk, in0, in1, out);
  wire _0_;
  input clk;
  input in0;
  input in1;
  wire in1_sh;
  output out;
  sky130_fd_sc_hd__inv_2 _1_ (
    .A(clk),
    .Y(_0_)
  );
  sky130_fd_sc_hd__mux2_1 _2_ (
    .A0(in0),
    .A1(in1_sh),
    .S(clk),
    .X(out)
  );
  \$_DLATCH_P_  _3_ (
    .D(in1),
    .E(_0_),
    .Q(in1_sh)
  );
endmodule
