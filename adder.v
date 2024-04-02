`include "cla.v"
module adder(   input [31:0] A,B,
                input Cin, sub,
                output [31:0]sum,
                output Cout);
        
        
        
        wire car; assign car = Cin|sub;
        wire c1,cout;
        wire [31:0]res1,res;

        CLA_16bit a1(.s(res1[15:0]),.cout(c1),.a(A[15:0]),.b(B[15:0]),.cin(car));
        CLA_16bit a2(.s(res1[31:16]),.cout(cout),.a(A[31:16]),.b(B[31:16]),.cin(c1));
        //assign {cout,res1} =  (A + B + (car)); //sum is Subtraction without Cin 
        
        assign Cout = (cout ^(sub & ~(A>(~B))));
        






        //For subtraction when Cin is 1
        wire [31:0]w; assign w[0]  = Cin & sub;                  
        genvar i;
        for(i = 0; i < 31; i = i+1)begin
                assign sum[i] = res1[i]^(w[i]);
                assign w[i+1] = w[i] & sum[i];
        end
                assign sum[31] = res1[31]^(w[31]);


endmodule