`timescale 1ns / 1ps

module encryption(
            clk,
            data,
            data_state,
            encoded_data,
            encoded_state         
    );
input [127:0] data;
input         clk,data_state;
output [127:0]encoded_data;
output        encoded_state;         


//change these to change baud rate
parameter clock_speed=100000000;//speed of the FPGA clock
parameter baud_rate=9600;//the number of bits you need per second
parameter clock_per_bit=10417;// number of clock cycles your hardware can afford per bit

//states
reg state=1'b0;//STATES
localparam init=1'b0,encode=1'b1;//states

reg  [127:0] key=128'h5468617473206d79204b756e67204675;
reg  [127:0] temp_encoded_data=1;
reg temp_encoded_state=0;;
reg[24:0] clock_counter=24'b0;//counts how many clock cycles passed
reg[24:0] temp_clock_counter=24'b0;//counts how many clock cycles passed

wire [127:0] encrypted_data;

encrypter DUT2(data,key,encrypted_data);
always@(posedge clk) begin
case (state)
init:
    begin
    if(temp_clock_counter==clock_per_bit<<8 )
    begin
        temp_encoded_data<=128'b1; 
        
    end
    else
    begin
        temp_clock_counter<=temp_clock_counter+1;
    end
     
    if (clock_counter==clock_per_bit<<3)
    begin
       temp_encoded_state<=1'b0;
    end
    else
    begin
        clock_counter<=clock_counter+1;
    end
   
    if (data_state==1)
    begin
        clock_counter<=0;
        state<=encode;
        temp_clock_counter<=0;
        temp_encoded_state<=1'b0;
    end
    end
encode:
    begin
    if (clock_counter==clock_per_bit*159)
    begin
       temp_encoded_state<=1'b1;
       clock_counter<=0;
       state<=init;          
       temp_encoded_data<=encrypted_data; 

    end
        else
    begin
        clock_counter<=clock_counter+1;

    end

    end
endcase
end
assign encoded_state=temp_encoded_state;
assign encoded_data=temp_encoded_data;
endmodule
//encrypter DUT2(data_out_rx,key,encrypted_data);