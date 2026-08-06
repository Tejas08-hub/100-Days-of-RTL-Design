module test;
reg clk;
reg reset;
wire[3:0]lfsr_out;
top_module dut(
    .clk(clk),
    .reset(reset),
    .lfsr_out(lfsr_out));
initial clk=0;
always #5 clk=~clk;
initial begin
reset=1;
#20;reset=0;
#150;reset=1;
#10;$finish;
end
endmodule