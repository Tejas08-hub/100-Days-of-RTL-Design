module top_module(
    input  clk_dest,
    input  reset,     
    input  async_in,      
    output reg sync_out
);
reg stage1;
always@(posedge clk_dest)begin
  if(reset)begin
       stage1<=0;
       sync_out<=0;
  end
   else begin
       stage1<=async_in;
       sync_out<=stage1;
  end
 end
endmodule