module test;
reg clk,reset,d_in;
wire sync_out;
wire async_out;
initial clk=0;
always #5 clk=~clk;
sync_reset dut1(
 .clk(clk),
 .reset(reset),
 .d_in(d_in),
 .sync_out(sync_out));
 async_reset dut2(
  .clk(clk),
  .reset(reset),
  .d_in(d_in),
  .async_out(async_out));
initial begin
reset = 0; d_in = 0;
#6  d_in = 1;
#2  reset = 1;
#3  reset = 0;
#9  d_in = 0;
#10 d_in = 1;
#7  reset = 1;
#12 reset = 0;
#8  d_in = 0;
#10 d_in = 1;
#15 d_in = 0;
#20 $finish;
end
endmodule