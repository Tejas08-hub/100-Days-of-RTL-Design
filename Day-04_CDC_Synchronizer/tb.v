module tb;
reg clk_dest;
reg reset;
reg async_in;
wire sync_out;
initial clk_dest=0;
always #5 clk_dest=~clk_dest;
top_module dut(
.clk_dest(clk_dest),
.reset(reset),
.async_in(async_in),
.sync_out(sync_out));
initial begin
 async_in=0;
 reset=1;
#10;reset=0;
    async_in=1;
#4; async_in=0;
#9; async_in=1;
#13; async_in=0;
#19; async_in=1;
#24; async_in=0;
end 
endmodule
