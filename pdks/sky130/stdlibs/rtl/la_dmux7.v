
module la_dmux7(sel6, sel5, sel4, sel3, sel2, sel1, sel0, in6, in5, in4, in3, in2, in1, in0, out);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input in0;
  input in1;
  input in2;
  input in3;
  input in4;
  input in5;
  input in6;
  output out;
  input sel0;
  input sel1;
  input sel2;
  input sel3;
  input sel4;
  input sel5;
  input sel6;
  sky130_fd_sc_hd__and2_2 _4_ (
    .A(in1),
    .B(sel1),
    .X(_0_)
  );
  sky130_fd_sc_hd__a22o_2 _5_ (
    .A1(in0),
    .A2(sel0),
    .B1(in5),
    .B2(sel5),
    .X(_1_)
  );
  sky130_fd_sc_hd__a22o_2 _6_ (
    .A1(in2),
    .A2(sel2),
    .B1(in3),
    .B2(sel3),
    .X(_2_)
  );
  sky130_fd_sc_hd__a22o_2 _7_ (
    .A1(in4),
    .A2(sel4),
    .B1(in6),
    .B2(sel6),
    .X(_3_)
  );
  sky130_fd_sc_hd__or4_2 _8_ (
    .A(_0_),
    .B(_1_),
    .C(_2_),
    .D(_3_),
    .X(out)
  );
endmodule
