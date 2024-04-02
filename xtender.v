module sp_extender( input [7:0]dp_data,
                    input [11:0]ld_data,
                    input ExtendSrc,
                    output [31:0]Ext_data);
    
    
        assign Ext_data = ~ExtendSrc ? {{24{dp_data[7]}},dp_data}:{{20{ld_data[11]}},ld_data};
endmodule