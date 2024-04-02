`include "logical_shifter.v"
module barrel_shifter(idata,index,shift,shft_amnt,Rs,datapr,ldstr,ALUSrcB,shiftSrc);
    input [31:0]idata;
    input [1:0]shift;       //Type of shift
    input [4:0]shft_amnt;   //Shift amount
    input [31:0]Rs;          //Shift amount from register
    input shiftSrc;

    //Inputs coming from Control Unit
    input   datapr,ldstr,   //which type of instruction is running
            //shft_type,    //ExtendSrc from Control Unit
            ALUSrcB;        //ALUSrcB to choose which data to shift
    //

    output reg [31:0]index;
    
    //Shifter
    reg [31:0]data; wire [31:0]result;
    reg [4:0]shft_amount;
    reg [1:0]dir;
    shifter s(  .data(data),
                .shft_amnt(shft_amount),
                .dir(dir),
                .result(result)
                );
    //
   
   
    
    //Shifter Control code
    always @(*) begin
      //For data processing addressing mode
      if(datapr)begin
      
      data = idata;
        if(ALUSrcB) begin
          dir  = 2'b11;
          shft_amount = {{1'b0},{shft_amnt[4:1]}};
        end

        else begin
          dir = shift;
          if(~shiftSrc) begin
            if(shft_amnt != 0)begin
              shft_amount = shft_amnt;
              dir = shift[1:0];
            end
            else begin

            end
          end
          else begin
           
            
            if(Rs[7:0]==0)begin
              
            end
            else if(~(Rs[5]|Rs[6]|Rs[7]))begin
              shft_amount = 5'd31;
              dir = 2'd0;
            end
            else if(Rs[5]|Rs[6]|Rs[7])begin
              shft_amount = Rs[4:0];
              dir = shift[1:0];
            
            end

          end
      
        end
 
      end
      
      //For load store addressing mode
      else if(ldstr)  begin
        data = idata;
        if(ALUSrcB) begin
          dir  = 2'b00;
          shft_amount = 5'd0;
        end
        else begin
           case (shift[1:0])
              2'b00:        /* LSL */
                begin
                  shft_amount = shft_amnt;
                  dir = shift[1:0];     
                  //index = Rm Logical_Shift_Left shft_amnt
                end
              2'b01:        /* LSR */
                begin
                  if (shft_amnt == 5'd0) begin /* LSR #32 */
                    shft_amount = 32'd32;
                    dir = shift[1:0]; 
                    //index = 0
                  end
                  else  begin
                    shft_amount = shft_amnt;
                    dir = shift[1:0]; 
                    //index = Rm Logical_Shift_Right shft_amnt
                  end
                end
              2'b10:        /* ASR */
                begin
                  if (shft_amnt == 5'd0) begin /* ASR #32 */
                    if (data[31] == 1) begin
                      shft_amount = 32'd31;
                      dir = shift[1:0];
                    //index = 0xFFFFFFFF
                    end
                    else  begin
                      shft_amount = 32'd32;
                      dir = 2'b00;
                    //index = 0
                    end
                  end
                  else  begin
                    shft_amount = shft_amnt;
                    dir = shift[1:0]; 
                    //index = Rm Arithmetic_Shift_Right shft_amnt
                  end
                end
              2'b11:        /* ROR or RRX */
                begin
                  if (shft_amnt == 5'd0) begin/* RRX */
                    shft_amount = shft_amnt;
                    dir = 2'b01;
                    //index = (C Flag Logical_Shift_Left 31) OR (Rm Logical_Shift_Right 1)
                  end
                  else begin     /* ROR */
                    shft_amount = shft_amnt;
                    dir = shift[1:0];
                    //index = Rm Rotate_Right shft_amnt
                  end
                end
            endcase
        end //
      
      
      
      end
    
    index = result;
    end

    
    //Carry bit codes here
    /*always @(*) begin
      
    end */
    //

endmodule