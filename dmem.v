module datamem(AD1,WD,WE,R,clk,rst);

input [31:0] AD1, WD;
input clk,rst,WE;

output [31:0] R;

reg [31:0] data_mem [31:0];
//read
assign R = (WE==1'b0) ? data_mem[AD1] : 32'h00000000;

//write

always @ (posedge clk) begin

if (WE)begin
data_mem[AD1]  <= WD;

end


end





endmodule