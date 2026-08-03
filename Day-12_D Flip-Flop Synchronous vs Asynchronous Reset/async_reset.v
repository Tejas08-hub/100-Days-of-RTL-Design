module async_reset(
input clk,
input reset,
input d_in,
output reg async_out);
always@(posedge clk or posedge reset)begin
   if(reset)
     async_out<=0;
     else
     async_out<=d_in;
     end
endmodule