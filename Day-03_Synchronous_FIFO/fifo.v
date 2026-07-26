module fifo#(
parameter width=8,
parameter depth=8)
(
input clk,
input reset,
input wr_en,
input [width-1:0]d_in,
input rd_en,
output reg[width-1:0]d_out,
output full,
output empty);
localparam depth_log=$clog2(depth);
reg[width-1:0]mem[0:depth-1];
reg[depth_log:0]wr_ptr;
reg[depth_log:0]rd_ptr;
always@(posedge clk)begin
  if(reset)
    wr_ptr<=0;
  else if(wr_en &&(!full || rd_en))begin
     mem[wr_ptr[depth_log-1:0]]<=d_in;
     wr_ptr<=wr_ptr+1;
  end
end
always@(posedge clk)begin
  if(reset)begin
    rd_ptr<=0;
    d_out <= 0;
  end
  else if(rd_en && (!empty))begin
    d_out<=mem[rd_ptr[depth_log-1:0]];
    rd_ptr<=rd_ptr+1;
   end
  end
  assign empty=(rd_ptr==wr_ptr);
  assign full=({~wr_ptr[depth_log],wr_ptr[depth_log-1:0]}==rd_ptr);
  endmodule