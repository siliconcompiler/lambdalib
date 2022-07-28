
module la_dmux3(sel2, sel1, sel0, in2, in1, in0, out);
  wire _0_;
  input in0;
  input in1;
  input in2;
  output out;
  input sel0;
  input sel1;
  input sel2;
  sky130_fd_sc_hd__a22o_2 _1_ (
    .A1(in1),
    .A2(sel1),
    .B1(in2),
    .B2(sel2),
    .X(_0_)
  );
  sky130_fd_sc_hd__a21o_2 _2_ (
    .A1(in0),
    .A2(sel0),
    .B1(_0_),
    .X(out)
  );
endmodule
