`timescale 1ns/1ps
module baud_rate_generator(
input clk,
input reset,
output reg baud_tick);
parameter freq=1000;
parameter baud=100;
localparam ccpt=freq/baud;
reg[12:0] count;
always@(posedge clk)begin
   if(reset)begin
      count<=0;
      baud_tick<=0;
      end
   else if(count==ccpt-1)begin
      count<=0;
      baud_tick<=1;
      end
   else begin
       count<=count+1'b1;
       baud_tick<=0;
       end
   end
 endmodule
       
  