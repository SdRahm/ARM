module reg_file(ADRS1,ADRS2,ADRS3,WRTD,WRTEN,FlagUpdate,clk,rst,RD1,RD2,RD3,RD4,N,Z,C,V,N_w,Z_w,C_w,V_w);


	input clk,rst;// clk and reset
	input [3:0] ADRS1,ADRS2,ADRS3;//address ports
	input [31:0] WRTD; //writeport
	input WRTEN,FlagUpdate;	//read/write enable
	input N_w,Z_w,C_w,V_w;
	output reg [31:0] RD1,RD2,RD3,RD4; //Output port
	output reg N,Z,C,V;



	// creation of regfile

	reg [31:0] registers [0:15];


	//read functionality
	
	always @ (negedge clk) begin
	
	

    RD1 <= (~rst) ? 32'h00000000 : registers [ADRS1]; 
	RD2 <= (~rst) ? 32'h00000000 : registers [ADRS2];	// Destination register
	
    RD3 <= (~rst) ? 32'h00000000 : registers [ADRS3];	// Shift amount from register
    RD4 <= (~rst) ? 32'h00000000 : registers [4'd15];
	
	// Write data to the registers
	if(WRTEN)
    begin

		registers[ADRS2] <= WRTD; 

	end

	// Updating the flags
	if(FlagUpdate)
    begin

		registers[13][31:28] <= {N_w,Z_w,C_w,V_w}; // UPDATING NZCV IN CPSR

	end

	end
	
	always @(negedge clk)begin
		{N,Z,C,V} <= (~rst) ? 4'h0 : registers[13] [31:28];	//CPSR WHERE NZCV FLAG IS PRESENT
	end

	/*initial begin
	registers [0] = 32'd4;
	registers [1] = 32'd3;
	registers [2] = 32'd2;
	registers [3] = 32'd6;
	registers [13][31:28] = 4'h0;
	
	end*/

	




endmodule