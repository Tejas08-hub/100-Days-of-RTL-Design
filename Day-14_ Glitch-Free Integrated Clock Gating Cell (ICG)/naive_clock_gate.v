module naive_clock_gate(
   input clk,
   input enable,
   output naive_clk_out);
assign naive_clk_out=clk & enable;
endmodule