module top_module(
  input clk,reset,se,
  input [3:0] d,        
  input scan_in,
  output scan_out,
  output [3:0] q         
);
scan_ff d1(.clk(clk),.reset(reset),.se(se),.d_in(d[0]),.si(scan_in),.q(q[0]));
scan_ff d2(.clk(clk),.reset(reset),.se(se),.d_in(d[1]),.si(q[0]),.q(q[1]));
scan_ff d3(.clk(clk),.reset(reset),.se(se),.d_in(d[2]),.si(q[1]),.q(q[2]));
scan_ff d4(.clk(clk),.reset(reset),.se(se),.d_in(d[3]),.si(q[2]),.q(q[3]));
assign scan_out=q[3];
endmodule


  