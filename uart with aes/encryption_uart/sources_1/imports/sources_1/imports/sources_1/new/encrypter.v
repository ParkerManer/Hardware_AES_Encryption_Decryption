`timescale 1ns / 1ps


module encrypter(
clear_data,
key,
encrypted_data
    );

input  [0:127] clear_data;
input  [0:127] key;
output [0:127] encrypted_data;

wire  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;

key keygen(key,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);
main encrypt(clear_data,encrypted_data,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);
endmodule