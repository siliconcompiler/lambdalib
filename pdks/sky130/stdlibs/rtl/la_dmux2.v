
module la_dmux2(sel1, sel0, in1, in0, out);
  input in0;
  input in1;
  output out;
  input sel0;
  input sel1;
  sky130_fd_sc_hd__a22o_2 _0_ (
    .A1(in0),
    .A2(sel0),
    .B1(in1),
    .B2(sel1),
    .X(out)
  );
endmodule
