module top_module #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  reset,   // synchronous, active high, resets to 0
    input                  en,      // count enable
    output [WIDTH-1:0] gray_out
);
reg[WIDTH-1:0] binary;
always@(posedge clk)begin
  if(reset)
   binary<=0;
  else if(en)
  binary<=binary+1'b1;
  end
assign gray_out=(binary^(binary>>1));
endmodule