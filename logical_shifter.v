module shifter(data,shft_amnt,dir,result);
    
    input [31:0]data;
    input [4:0]shft_amnt;
    input [1:0]dir;  //decides whether left /right shift or arithmetic right shift/rotate
    
    output reg [31:0]result;
    
    reg [30:0]rot;
    reg [31:0]rshft;

    reg [62:0]data1;
    always @(*) begin
      data1 = {{data},{31{1'd0}}};
    end

    always @(*) begin
      if(dir == 2'b00)begin
        result = data << shft_amnt;                 //logical left shift
      end
      
      else begin
        {rshft,rot} = data1 >> shft_amnt;
            if(dir == 2'b01) 
                result = rshft;                     //logical right shift
            else if(dir == 2'b10)begin 
                result = data >>> shft_amnt;  // Arithmetic right shift
            end
            else begin
                result = rshft | rot;
            end
      end
    
    end
endmodule