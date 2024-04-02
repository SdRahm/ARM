module mux(A,B,S,Y);



input  S;
input  [31:0]A,B;

output   [31:0]Y;



assign Y = (S == 1'b0) ? A:B; // if S = 0 ==> Y = A otherwise Y = B




endmodule