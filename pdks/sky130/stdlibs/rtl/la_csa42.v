
module la_csa42(a, b, c, d, cin, sum, carry, cout);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  input a;
  input b;
  input c;
  output carry;
  input cin;
  output cout;
  input d;
  output sum;
  sky130_fd_sc_hd__nand2_2 _07_ (
    .A(a),
    .B(b),
    .Y(_06_)
  );
  sky130_fd_sc_hd__o21ai_2 _08_ (
    .A1(a),
    .A2(b),
    .B1(c),
    .Y(_00_)
  );
  sky130_fd_sc_hd__nand2_2 _09_ (
    .A(_06_),
    .B(_00_),
    .Y(cout)
  );
  sky130_fd_sc_hd__or3_2 _10_ (
    .A(c),
    .B(a),
    .C(b),
    .X(_01_)
  );
  sky130_fd_sc_hd__and3_2 _11_ (
    .A(c),
    .B(a),
    .C(b),
    .X(_02_)
  );
  sky130_fd_sc_hd__a31o_2 _12_ (
    .A1(_06_),
    .A2(_00_),
    .A3(_01_),
    .B1(_02_),
    .X(_03_)
  );
  sky130_fd_sc_hd__xnor2_2 _13_ (
    .A(d),
    .B(_03_),
    .Y(_04_)
  );
  sky130_fd_sc_hd__xnor2_2 _14_ (
    .A(cin),
    .B(_04_),
    .Y(sum)
  );
  sky130_fd_sc_hd__o21a_2 _15_ (
    .A1(d),
    .A2(_03_),
    .B1(cin),
    .X(_05_)
  );
  sky130_fd_sc_hd__a21o_2 _16_ (
    .A1(d),
    .A2(_03_),
    .B1(_05_),
    .X(carry)
  );
endmodule
