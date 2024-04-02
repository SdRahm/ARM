module control(
	input [31:0]ins,
	input [31:0]pc,
	input clk,rst,
	input N_flag,Z_flag,C_flag,V_flag,	//CPSR Flags
	output [3:0] ALUControl,
	output RegWrite,RegWriteLdst,ALUSrcB,MemWrite,MemtoReg,ExtendSRC,FlagUpdate,
            MemSrcB,datapr,ldstr,
    
    //Multiplier ios
    //input accum, word_multi,typ;
    //output multiply,multi_x,multi_y,
    
    //Shifter output
    output [1:0]shift,
    output [4:0]shft_amnt,
    output shiftSrc);
	
	
	wire [3:0]ALUContr; assign ALUContr = ins[24:21];


	//Condition check BEGINS
	wire ConditionPassed;
    
    assign ConditionPassed = (ins[31:28] == 4'd14)|
    ((ins[31:28] == 4'd0) & Z_flag)|((ins[31:28] == 4'd1) & ~Z_flag)|
    ((ins[31:28] == 4'd2) & C_flag)|((ins[31:28] == 4'd3) & ~C_flag)|
    ((ins[31:28] == 4'd4) & N_flag)|((ins[31:28] == 4'd5) & ~N_flag)|
    ((ins[31:28] == 4'd6) & V_flag)|((ins[31:28] == 4'd7) & ~V_flag)|
    ((ins[31:28] == 4'd8) & (C_flag & ~Z_flag))|((ins[31:28] == 4'd9) & (~C_flag | Z_flag))|
    ((ins[31:28] == 4'd10) & (N_flag == V_flag))|((ins[31:28] == 4'd11) & (N_flag != V_flag))|
    ((ins[31:28] == 4'd12) & (~Z_flag & (N_flag == V_flag)))|((ins[31:28] == 4'd13) & (Z_flag | (N_flag != V_flag)));

    //Condition check ENDS
	
    // Codes to decide type of instuction   BEGIN
    
    assign ldstr = (ins[27:25]==3'd2)|| (ins[27:25]==3'd3);
    assign datapr = (ins[27:25]==3'd0 || ins[27:25]==3'd1);
    

    //END

    //Control Unit outputs code BEGINS
        

        assign MemtoReg = ((~datapr) | ldstr)
                            & ConditionPassed;	//Decides ALU result or memory data should go to the register

        assign ALUControl = (ins[24:21] & {4{datapr}}) |            //ALU operation decision for data processing
                            ({4{(ldstr & ins[23])}} & 4'b0100) |    // ALU add for load store
                            ({4{(ldstr & ~ins[23])}} & 4'b0010) ;	// ALU subtract for load store
                            

        assign RegWrite = (datapr)
                            & ~((ALUContr == 4'b1010)|(ALUContr == 4'b1011)|(ALUContr == 4'b1000)|(ALUContr == 4'b1001))
                            |(ldstr) & ins[20]
                            & ConditionPassed;	//Register write is enabled

        assign ExtendSRC = MemtoReg; 	        //Extend will extend 8 bits (for data processing) or 12 bits (for load store) immediate data

        assign ALUSrcB = ((datapr) & ins[25]) | (ldstr & ~ins[25]); //Decides whether immediate or register value will go to ALU

        assign MemWrite = ((ins[27:25]==3'd2)|(ins[27:25]==3'd3)|(ins[27:25]==3'd4)) &ins[20] & ConditionPassed;

        assign FlagUpdate = (datapr) & ins[20] & ConditionPassed; // Update flags if true
        
        assign MemSrcB = ins[24];   //U bit of load store instruction decides whether to use result fromm ALU or directly from shifter

        assign RegWriteLdst = ldstr;    //To update Rn rgister dring load store instructions

    //Control Unit outputs code ENDS

    //Barrel shifter control codes
        assign shift = ins[6:5];        //Shift type
        assign shft_amnt = ins[11:7];   //Shifting amount
        assign shiftSrc = ins[4];       //Mux input to choose from where to take shift amount 
    /////
        




  /*  // MUltiplication
    assign multiply = datapr & ins[7];
    assign multi_x = ins[5];
    assign multi_y = ins[6];
    //(Need to be added above)
    assign accum = 1'b0;        // Accumulator multiplication
    assign word_multi = 1'b0;   // Word multiplication
    assign typ = 1'b0;          // SIgned or Unsigned multiplication
 */


endmodule