module sync_reset(
input clk,
input reset,
input d_in,
output reg sync_out);
always@(posedge clk)begin
   if(reset)
     sync_out<=0;
   else 
     sync_out<=d_in;
   end 
endmodule