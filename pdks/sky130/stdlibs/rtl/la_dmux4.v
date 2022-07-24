
module la_dmux4(sel3, sel2, sel1, sel0, in3, in2, in1, in0, out);
  wire _0_;
  wire _1_;
  input in0;
  input in1;
  input in2;
  input in3;
  output out;
  input sel0;
  input sel1;
  input sel2;
  input sel3;
  sky130_fd_sc_hd__a22o_2 _2_ (
    .A1(in1),
    .A2(sel1),
    .B1(in2),
    .B2(sel2),
    .X(_0_)
  );
  sky130_fd_sc_hd__a22o_2 _3_ (
    .A1(in0),
    .A2(sel0),
    .B1(in3),
    .B2(sel3),
    .X(_1_)
  );
  sky130_fd_sc_hd__or2_2 _4_ (
    .A(_0_),
    .B(_1_),
    .X(out)
  );
endmodule
