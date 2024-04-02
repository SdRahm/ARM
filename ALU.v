`include "adder.v"

module ALU(A,B,Cin,Result,Cout,ALUControl,FlagUpdate,V,C,Z,N,V_flag);
    parameter DATA_WIDTH = 32;

    input [DATA_WIDTH-1:0]A,B;
    input [3:0]ALUControl;
    input Cin;
    input FlagUpdate;
    input V_flag;
    output reg N,Z,C,V;
    output [DATA_WIDTH-1:0]Result;
    output Cout;

    // Inputs of the adder
    wire [DATA_WIDTH-1:0] I1,I2;
    wire Car,sub;

    // Outputs of the adder
    wire cout;
    wire [DATA_WIDTH-1:0]sum;

    
    // Deciding on how the inputs will go to the adder
    assign {I1,I2,Car,sub} =    (ALUControl == 4'b0010) ? {A,~B,1'b0,1'b1}: // A - B
                                (ALUControl == 4'b0011) ? {B,~A,1'b0,1'b1}: // B - A
                                (ALUControl == 4'b0100) ? {A,B,1'b0,1'b0}:  // A + B
                                (ALUControl == 4'b0101) ? {A,B,Cin,1'b0}:   // A + B + Cin
                                (ALUControl == 4'b0110) ? {A,~B,Cin,1'b1}:   // A - B - Cin
                                (ALUControl == 4'b0111) ? {B,~A,Cin,1'b1}:  // B - A - Cin
                                {31'd0,31'd0,1'd0,1'd0};


    //Adder
    adder a1(   .A(I1),
                .B(I2),
                .Cin(Car),
                .sub(sub),
                .sum(sum),
                .Cout(cout));

    //Final Output of the ALU
    assign {Cout,Result} =   (ALUControl == 4'b0010) |(ALUControl == 4'b1010)|  // A - B
                             (ALUControl == 4'b0011) |  // B - A
                             (ALUControl == 4'b0100) |(ALUControl == 4'b1011)| // A + B
                             (ALUControl == 4'b0101) |  // A + B + Cin
                             (ALUControl == 4'b0110) |  // A - B - Cin
                             (ALUControl == 4'b0111)    // B - A -cin
                             ? {cout, sum}:
                             (ALUControl == 4'b0000)|(ALUControl == 4'b1000) ? (A & B) :  // AND operation
                             (ALUControl == 4'b1100) ? (A | B) :  // OR operation
                             (ALUControl == 4'b1101) ? (B) :      //MOV
                             (ALUControl == 4'b0001)|(ALUControl == 4'b1001) ? (A ^ B) : // EX_OR operation.
                             (ALUControl == 4'b1110)? (A & ~B):
                             (ALUControl == 4'b1111)? ~B:
                             32'd0; 


    /*assign {Cout,Result} = (ALUControl == 4'b0100) ? A + B : // ADD
                           (ALUControl == 4'b0000) ? A & B :  // AND operation
                           (ALUControl == 4'b1100) ? A | B :  // OR operation
                           (ALUControl == 4'b0010) ? A - B : // Subtarct
                           (ALUControl == 4'b0011) ? B - A : // Reverse Subtract
                           (ALUControl == 4'b0101) ? A + B + Cin : // ADD with carry
                           (ALUControl == 4'b0110) ? A - B - Cin : // Subtract with carry
                           (ALUControl == 4'b0111) ? B - A - Cin : // Reverse Subtract with carry
                           (ALUControl == 4'b0001) ? A ^ B : 32'd0; // EX_OR operation.
     */                      







    always @(*) begin

    if(FlagUpdate) begin

        N <= Result[DATA_WIDTH-1];
        Z <= (Result == 32'd0) ? 1 : 0;
        C <= Cout; 
        

                
        V <= (ALUControl == 4'b0010) | (ALUControl == 4'b0011)?(A[31] == B[31]) & (A[31] == ~Result[31]):
                    (ALUControl == 4'b0100 )| (ALUControl == 4'b0101)?(A[31] == ~B[31]) & (A[31] == ~Result[31]):
                    V_flag;
    
    end
    end
endmodule