`timescale 1ns / 1ps

module main(
clear_data,
encrypted_data,
key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10
    );
input  [0:127] clear_data;
input  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;
output [0:127] encrypted_data;
wire   [0:127] data_with_key[0:9];
wire   [0:127] data_after_subs[0:9];
wire   [0:127] data_after_shift[0:9];
wire   [0:127] data_after_mixcol[0:8];
wire   [0:127] key[0:11];

assign key[0] =key_0;
assign key[1] =key_1;
assign key[2] =key_2;
assign key[3] =key_3;
assign key[4] =key_4;
assign key[5] =key_5;
assign key[6] =key_6;
assign key[7] =key_7;
assign key[8] =key_8;
assign key[9] =key_9;
assign key[10]=key_10;


addRoundKey  RiA (clear_data,key[0],data_with_key[0]);
genvar i;
generate
    for(i=0;i<9;i=i+1)begin        
    substitution RiSB(data_with_key[i],data_after_subs[i]);
    shift_rows   RiSR(data_after_subs[i],data_after_shift[i]);
    mix_col      RiMC(data_after_shift[i],data_after_mixcol[i]);   
    addRoundKey  RiAk (data_after_mixcol[i],key[i+1],data_with_key[i+1]); 
    end
endgenerate
substitution RFSB(data_with_key[9],data_after_subs[9]);
shift_rows   RFSR(data_after_subs[9],data_after_shift[9]);
addRoundKey  RFAk (data_after_shift[9],key[10],encrypted_data); 

endmodule
