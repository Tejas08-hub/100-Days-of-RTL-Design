module top_module(
  input clk,
  input enable,
  output gated_clk);
  reg enb_latch;
always@(*)begin
    if(!clk)
     enb_latch=enable;
    end
assign gated_clk= clk & enb_latch;
endmodule