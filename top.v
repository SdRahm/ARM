`include "ALU.v"
`include "dmem.v"
`include "reg_file.v"
`include "xtender.v"
`include "control.v"
`include "mux.v"
`include "barrel_shifter.v"





module top(clk,rst,ins);

input clk,rst;
input [31:0]ins;


wire [31:0] Reg2ALU, Reg2Mem,Ext_data,aluresult,memdata,mux2reg,regx2shft,m2alu;
wire[31:0] pc,ins2ff,pc2addr,nxtpc,r15;
wire N,Z,C,V,RegWrite,ALUSrcB,MemWrite,MemtoReg,ExtendSRC,datapr,ldstr;
wire [3:0] ALUControl;
wire cr13,nr13,zr13,vr13;//to be checked!!!!
 
/*//PC codes
wire [3:0]pc_cnt; wire [31:0] ins1;
pc_adder p1(.x(4'd0),
            .clk(clk),
            .y(pc_cnt));
instr_mem i1(   .ADRS(pc_cnt), 
                .RD(ins1), 
                .rst(rst)); 
*/

//Shifter's control signals 
wire [1:0]shift;
wire [4:0]shft_amnt;
wire shiftSrc;


 control ctrl
(
    .ins(ins),              //input
    .N_flag(N),             //input
    .Z_flag(Z),             //input
    .C_flag(C),             //input
    .V_flag(V),             //input
    .ALUControl(ALUControl),
    .RegWrite(RegWrite),
    .ALUSrcB(ALUSrcB),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ExtendSRC(ExtendSRC),
    .datapr(datapr),
    .ldstr(ldstr),
    .shift(shift),
    .shft_amnt(shft_amnt),
    .shiftSrc(shiftSrc)
);


reg_file r (
    .clk(clk),              //input
    .rst(rst),              //input
    .ADRS1(ins[19:16]),     //input
    .ADRS2(ins[15:12]),     //input
    .ADRS3(ins[11:8]),      //input
    .WRTEN(RegWrite),       //input
    .WRTD(mux2reg),         
    .RD1(Reg2ALU),          
    .RD2(Reg2Mem),
    .RD3(regx2shft),
    .RD4(r15),
    .N_w(nr13),             
    .Z_w(zr13),
    .C_w(cr13),
    .V_w(vr13),
    .N(N),
    .Z(Z),
    .C(C),
    .V(V)

);


sp_extender spx (
    
    .dp_data(ins[7:0]),         //input
    .ld_data(ins[11:0]),        //input
    .ExtendSrc(ExtendSRC),      //input
    .Ext_data(Ext_data)

);

wire [31:0]Bs2ALU;

barrel_shifter bs(
                        .idata(Ext_data),       //input    
                        .index(Bs2ALU),         //output
                        .shift(shift),          //input
                        .shft_amnt(shft_amnt),  //input
                        .Rs(regx2shft),         //input
                        .datapr(datapr),        //input
                        .ldstr(ldstr),          //input
                        .ALUSrcB(ALUSrcB),      //input
                        .shiftSrc(shiftSrc)     //input
                        );


assign m2alu = Bs2ALU;


ALU alu (
    .A(Reg2ALU),                //input
    .B(m2alu),                  //input
    .Cin(C),                    //input
    .ALUControl(ALUControl),    //input
    .V_flag(V),                 
    .N(nr13),                   
    .Z(zr13),                     
    .V(vr13),
    .C(cr13),
    .Result(aluresult)    

);



datamem dm(
    .AD1(aluresult),        //input
    .WD(Reg2Mem),           //input
    .clk(clk),              //input
    .rst(rst),              //input
    .WE(MemWrite),          //input
    .R(memdata)


);

mux m1(
    .A(aluresult),          //input
    .B(memdata),            //input
    .Y(mux2reg),
    .S(MemtoReg)            //input

);

/*mux m2(                             //Which data to send to ALU Extend's or Register's
    .A(regx2alu),
    .B(Bs2ALU),
    .Y(m2alu),
    .S(ALUSrcB)

);*/



endmodule