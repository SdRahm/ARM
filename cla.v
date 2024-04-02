`include "PFA.v" 
//Carry lookahead adder -8bit inputs

module CLA_16bit(a,b, cin, s,cout);
input [15:0] a,b;
input cin;
output [15:0] s;
output cout;
wire c1,c2,c3;

carry_look_ahead_4bit cla1 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(s[3:0]), .cout(c1));
carry_look_ahead_4bit cla2 (.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(s[7:4]), .cout(c2));
carry_look_ahead_4bit cla3(.a(a[11:8]), .b(b[11:8]), .cin(c2), .sum(s[11:8]), .cout(c3));
carry_look_ahead_4bit cla4(.a(a[15:12]), .b(b[15:12]), .cin(c3), .sum(s[15:12]), .cout(cout));

endmodule